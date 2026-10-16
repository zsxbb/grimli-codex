using Grimoire.Botting;
using Grimoire.Game.Data;
using Grimoire.Networking;
using Grimoire.Tools;
using Grimoire.UI;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace Grimoire.Game
{
    public class DropStack : IReadOnlyList<InventoryItem>, IReadOnlyCollection<InventoryItem>, IEnumerable<InventoryItem>, IEnumerable
    {
        private readonly List<InventoryItem> _drops = new List<InventoryItem>();
        private readonly Dictionary<int, Stopwatch> _cooldowns = new Dictionary<int, Stopwatch>();
        private readonly object _lock = new object();

        public int Count
        {
            get
            {
                lock (_lock)
                {
                    return _drops.Count;
                }
            }
        }

        public InventoryItem this[int index]
        {
            get
            {
                lock (_lock)
                {
                    if (index >= 0 && index < _drops.Count)
                    {
                        return _drops[index];
                    }
                    return null;
                }
            }
        }

        public DropStack()
        {
            World.ItemDropped += OnItemDropped;
        }

        public IEnumerator<InventoryItem> GetEnumerator()
        {
            List<InventoryItem> copy;
            lock (_lock)
            {
                copy = new List<InventoryItem>(_drops);
            }
            return copy.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        private void OnItemDropped(InventoryItem item)
        {
            if (item == null) return;
            lock (_lock)
            {
                if (_drops.All((InventoryItem d) => d.Id != item.Id))
                {
                    _drops.Add(item);
                }
            }
            DropUi.instance?.AddItem(item);
        }

        public async Task<bool> GetDrop(string itemName)
        {
            if (string.IsNullOrWhiteSpace(itemName))
                return false;

            string cleanName = itemName.Trim();

            // 1. If numeric Item ID (e.g. "46053")
            if (int.TryParse(cleanName, out int parsedId) && parsedId > 0)
            {
                return await GetDrop(parsedId);
            }

            // 2. Look up in current DropStack
            InventoryItem inventoryItem = null;
            lock (_lock)
            {
                inventoryItem = _drops.FirstOrDefault((InventoryItem d) => d.Name != null && d.Name.EqualsIgnoreCase(cleanName));
            }

            if (inventoryItem != null)
            {
                return await GetDrop(inventoryItem.Id);
            }

            // 3. Fallback: Search in World.ItemTree to get the itemId
            try
            {
                var treeItem = World.ItemTree?.FirstOrDefault(i => i.Name != null && i.Name.EqualsIgnoreCase(cleanName));
                if (treeItem != null && treeItem.Id > 0)
                {
                    return await GetDrop(treeItem.Id);
                }
            }
            catch { }

            return false;
        }

        public async Task<bool> GetDrop(int itemId)
        {
            if (itemId <= 0)
                return false;

            InventoryItem drop = null;
            lock (_lock)
            {
                drop = _drops.FirstOrDefault(d => d.Id == itemId);
            }

            // If not found in DropStack, check ItemTree
            if (drop == null)
            {
                try
                {
                    drop = World.ItemTree?.FirstOrDefault(i => i.Id == itemId);
                }
                catch { }
            }

            // Drop Protection check (only for non-AC, non-temporary items when bot is actively running)
            if (drop != null && !drop.IsTemporary && !drop.IsAcItem && BotManager.Instance.ActiveBotEngine.IsRunning)
            {
                try
                {
                    if (!Player.Inventory.HasSpaceFor(drop))
                    {
                        LogForm.Instance.devDebug($"[DropProtection] Inventory full, delayed pickup for {drop.Name} ({drop.Id})");
                        return false;
                    }
                }
                catch { }
            }

            // Cooldown throttle (800ms) to prevent packet spam
            lock (_lock)
            {
                if (_cooldowns.TryGetValue(itemId, out Stopwatch sw))
                {
                    if (sw.ElapsedMilliseconds < 800)
                    {
                        return false;
                    }
                    sw.Restart();
                }
                else
                {
                    _cooldowns[itemId] = Stopwatch.StartNew();
                }
            }

            // Resolve RoomId with fallback retries
            int roomId = World.RoomId;
            if (roomId <= 0)
            {
                for (int i = 0; i < 5; i++)
                {
                    await Task.Delay(100);
                    roomId = World.RoomId;
                    if (roomId > 0) break;
                }
            }

            if (roomId <= 0)
            {
                try { roomId = Flash.Instance.GetGameObject<int>("world.curRoom"); } catch { }
            }

            if (roomId <= 0)
            {
                try { roomId = Flash.Instance.GetGameObject<int>("sfc.activeRoomId"); } catch { }
            }

            if (roomId <= 0)
            {
                LogForm.Instance.devDebug($"[GetDrop Error] Could not determine RoomId for item {itemId}");
                return false;
            }

            // Send packet to server: %xt%zm%getDrop%{roomId}%{itemId}%
            string packet = $"%xt%zm%getDrop%{roomId}%{itemId}%";
            await Proxy.Instance.SendToServer(packet);
            LogForm.Instance.devDebug($"[GetDrop] Sent: {packet}");
            return true;
        }

        public async Task<bool> GetDrop(InventoryItem item)
        {
            if (item == null) return false;
            return await GetDrop(item.Id);
        }

        public void Remove(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return;
            string clean = name.Trim();
            InventoryItem item = null;

            lock (_lock)
            {
                item = _drops.Find((InventoryItem d) => d.Name != null && d.Name.EqualsIgnoreCase(clean));
                if (item != null)
                {
                    _drops.Remove(item);
                }
            }

            if (item != null)
            {
                DropUi.instance?.RemoveItem(item.Name);
            }
            else
            {
                DropUi.instance?.RemoveItem(clean);
            }
        }

        public void Remove(int id)
        {
            if (id <= 0) return;
            InventoryItem item = null;

            lock (_lock)
            {
                item = _drops.Find((InventoryItem d) => d.Id == id);
                if (item != null)
                {
                    _drops.Remove(item);
                }
            }

            if (item != null)
            {
                DropUi.instance?.RemoveItem(item.Name);
            }
        }

        public void Clear()
        {
            lock (_lock)
            {
                _drops.Clear();
                _cooldowns.Clear();
            }
        }

        public bool Contains(InventoryItem item)
        {
            return item != null && Contains(item.Id);
        }

        public bool Contains(int itemId)
        {
            if (itemId <= 0) return false;
            lock (_lock)
            {
                return _drops.Any((InventoryItem d) => d.Id == itemId);
            }
        }

        public bool Contains(string itemName)
        {
            if (string.IsNullOrWhiteSpace(itemName)) return false;
            string clean = itemName.Trim();

            if (int.TryParse(clean, out int id))
            {
                return Contains(id);
            }

            lock (_lock)
            {
                return _drops.Any((InventoryItem d) => d.Name != null && d.Name.EqualsIgnoreCase(clean));
            }
        }
    }
}
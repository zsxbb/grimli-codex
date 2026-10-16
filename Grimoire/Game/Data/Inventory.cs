using Grimoire.Botting;
using Grimoire.Tools;
using Grimoire.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Caching;

namespace Grimoire.Game.Data
{
    public class Inventory
    {
        private List<InventoryItem> _cachedItems;
        private int _lastItemsFetchTick = 0;
        private readonly object _itemsLock = new object();

        public List<InventoryItem> Items
        {
            get
            {
                int now = Environment.TickCount;
                lock (_itemsLock)
                {
                    if (_cachedItems != null && (now - _lastItemsFetchTick) < 400 && (now - _lastItemsFetchTick) >= 0)
                    {
                        return _cachedItems;
                    }

                    try
                    {
                        var fetched = Flash.Call<List<InventoryItem>>("GetInventoryItems", new string[0]);
                        if (fetched != null)
                        {
                            _cachedItems = fetched;
                            _lastItemsFetchTick = now;
                            return _cachedItems;
                        }
                    }
                    catch { }

                    return _cachedItems ?? new List<InventoryItem>();
                }
            }
        }

        public void InvalidateCache()
        {
            lock (_itemsLock)
            {
                _cachedItems = null;
                _lastItemsFetchTick = 0;
            }
        }

        Dictionary<int, InventoryItem> _cache = new Dictionary<int, InventoryItem>();
        public Dictionary<int, InventoryItem> Cache
        {
            get
            {
                var _items = Items;
                _cache.Clear();
                foreach (var item in _items)
                {
                    _cache[item.Id] = item;
                }
                return _cache;
            }
        }


        public InventoryItem GetItemByName(string name)
        {
            return Flash.Call<InventoryItem>("GetInventoryItemByName", name);
        }

        public int MaxSlots => Flash.Call<int>("InventorySlots", new string[0]);

        public int UsedSlots => Flash.Call<int>("UsedInventorySlots", new string[0]);

        public bool HasInventoryCategories
        {
            get
            {
                try
                {
                    string res = Flash.GetGameObject("loaderInfo.applicationDomain.hasDefinition('InvCat')");
                    if (bool.TryParse(res, out bool has) && has)
                        return true;

                    string countBag = Flash.CallGameFunction("InvCat.countBag", "world.myAvatar.items");
                    return !string.IsNullOrEmpty(countBag);
                }
                catch
                {
                    return false;
                }
            }
        }

        public int BagUsedSlots
        {
            get
            {
                if (HasInventoryCategories)
                {
                    try
                    {
                        int bagCount = Flash.Instance.GetGameObject<int>("InvCat.countBag(world.myAvatar.items)");
                        if (bagCount > 0)
                            return bagCount;
                    }
                    catch { }
                }
                return UsedSlots;
            }
        }

        public int MiscSlots
        {
            get
            {
                try { return Flash.Instance.GetGameObject<int>("InvCat.MISC_SLOTS"); }
                catch { return 0; }
            }
        }

        public int MiscUsedSlots
        {
            get
            {
                try { return Flash.Instance.GetGameObject<int>("InvCat.countMisc(world.myAvatar.items)"); }
                catch { return 0; }
            }
        }

        public int MiscFreeSlots => Math.Max(0, MiscSlots - MiscUsedSlots);

        public int AvailableSlots => MaxSlots - (HasInventoryCategories ? BagUsedSlots : UsedSlots);

        public bool CanBank(InventoryItem item)
        {
            if (item == null)
                return false;
            if (item.Category != null && item.Category.EqualsIgnoreCase("Class"))
            {
                if (HasInventoryCategories)
                    return false;
            }
            return true;
        }

        public bool HasSpaceFor(InventoryItem item, int quantity = 1)
        {
            if (item == null)
                return false;

            var existing = Items.FirstOrDefault(i => i.Id == item.Id);
            if (existing != null && existing.Quantity + quantity <= existing.MaxStack)
                return true;

            if (HasInventoryCategories)
            {
                if (item.Category != null && (item.Category.EqualsIgnoreCase("Item") || item.Category.EqualsIgnoreCase("Quest Item")))
                {
                    return MiscFreeSlots > 0;
                }
                return (MaxSlots - BagUsedSlots) > 0;
            }

            return AvailableSlots > 0;
        }

        public bool IsFavorited(int itemId)
        {
            try
            {
                string favStoreCheck = Flash.CallGameFunction("liteAssets.draw.FavStore.has", itemId);
                if (bool.TryParse(favStoreCheck, out bool isFav) && isFav)
                    return true;

                bool treeFav = Flash.Instance.GetGameObject<bool>($"world.invTree[{itemId}].bFav");
                if (treeFav)
                    return true;
            }
            catch
            {
            }
            return false;
        }

        public bool IsFavorited(string itemName)
        {
            var item = GetItemByName(itemName);
            return item != null && IsFavorited(item.Id);
        }

        public bool ContainsItemX(string name, string quantity)
        {
            InventoryItem inventoryItem = Items.FirstOrDefault((InventoryItem i) => i.Name.EqualsIgnoreCase(name));
            if (inventoryItem != null)
            {
                if (!(quantity == "*"))
                {
                    return inventoryItem.Quantity >= int.Parse(quantity);
                }
                return true;
            }
            return false;
        }
        #region waitItemTaken
        /* public async Task<bool> WaitForItem(string itemName, int attempts = 3, int delayMS = 1000)
         {
             for (int i = 0; i < attempts; i++)
             {
                 bool found = Player.Inventory.Items.Any(it => it.Name.Equals(itemName, StringComparison.OrdinalIgnoreCase));

                 if (found)
                     return true;

                 await Task.Delay(delayMS);
             }
             return false;
         }
         public async Task<bool> WaitForItemId(int itemId, int attempts = 3, int delayMS = 1000)
         {
             for (int i = 0; i < attempts; i++)
             {
                 bool found = Player.Inventory.Items.Any(it => it.Id == itemId);

                 if (found)
                     return true;

                 await Task.Delay(delayMS);
             }
             return false;
         }*/
        #endregion

        public bool ContainsItem(string itemName, string quantity = "*")
        {
            InventoryItem item = Player.Inventory.GetItemByName(itemName);
            if (item == null)
            {
                return false;
            }
            else if (int.TryParse(quantity, out int qty))
            {
                if (ClientConfig.AutoCorrect && item.Category != "Class" && qty > item.MaxStack)
                    qty = item.MaxStack;
                return item.Quantity >= qty;
            }
            return true;
        }

        public bool ContainsItem(int id, int qty)
        {
            InventoryItem item = Items.FirstOrDefault((InventoryItem i) => i.Id == id);
            if (item == null)
            {
                return false;
            }
            else if (item.Category != "Class" && qty > item.MaxStack)
            {
                qty = item.MaxStack;
            }
            return item.Quantity >= qty;
            //return Items.FirstOrDefault((InventoryItem it) => it.Id == id)?.Quantity >= qty;
        }

        public int GetItemQty(string format)
        {//not yet used...
            format = format.Replace(".qty", "");
            return Items.FirstOrDefault(
                (InventoryItem i) => i.Name.EqualsIgnoreCase(format)
                )?.Quantity ?? 0;
        }

        public bool ContainsItem(InventoryItem item, Dictionary<int, InventoryItem> cache = null)
        {
            //Console.WriteLine($"checking for item [{item.Name}] on inv");
            if (cache != null)
                return cache.TryGetValue(item.Id, out var i) && i.Quantity >= item.Quantity;

            return Items.FirstOrDefault((InventoryItem target) => target.Id == item.Id)?.Quantity >= item.Quantity;
        }

        public bool ContainsMaxItem(string name)
        {
            InventoryItem inventoryItem = Items.FirstOrDefault((InventoryItem i) => i.Name.EqualsIgnoreCase(name));
            if (inventoryItem == null)
                return false;
            return inventoryItem.Quantity >= inventoryItem.MaxStack;
        }
    }
}

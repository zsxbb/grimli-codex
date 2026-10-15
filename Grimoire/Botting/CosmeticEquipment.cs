using Grimoire.Game;
using Grimoire.Networking;
using Grimoire.Tools;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;

namespace Grimoire.Botting
{
    public class CosmeticEquipment
    {
        private static readonly Dictionary<EquipType, string> _cosMap = new Dictionary<EquipType, string>()
        {
            { EquipType.Helm, "he" },
            { EquipType.Cape, "ba" },
            { EquipType.Armor, "co" },
            { EquipType.Class, "ar" },
            { EquipType.Pet, "pe" },
            { EquipType.Weapon, "Weapon" },
            { EquipType.Offhand, "Off" },
            { EquipType.Ground, "mi" }
        };

        private static readonly Dictionary<string, EquipType> _backMap = new Dictionary<string, EquipType>(StringComparer.OrdinalIgnoreCase)
        {
            { "he", EquipType.Helm },
            { "ba", EquipType.Cape },
            { "co", EquipType.Armor },
            { "ar", EquipType.Class },
            { "pe", EquipType.Pet },
            { "weapon", EquipType.Weapon },
            { "mi", EquipType.Ground },
            { "off", EquipType.Offhand }
        };

        public EquipType Slot { get; set; }

        [JsonProperty("ItemID")]
        public int ID { get; set; }

        [JsonProperty("sLink")]
        public string Link { get; set; }

        [JsonProperty("sMeta")]
        public string Meta { get; set; }

        [JsonProperty("sFile")]
        public string SWFFile { get; set; }

        [JsonProperty("sType")]
        public string Type { get; set; }

        public void Equip()
        {
            string slot = _cosMap.TryGetValue(Slot, out string s) ? s : "co";
            dynamic equip = new ExpandoObject();
            equip.sFile = SWFFile;
            equip.sLink = Link;
            equip.sType = Type ?? slot;
            equip.sMeta = Meta ?? "";
            if (ID != 0)
                equip.ItemID = ID;
            Flash.Call("SetEquip", new object[2] { slot, equip });
        }

        public override string ToString()
        {
            return $"{Slot}: {SWFFile};{Link}";
        }

        private static readonly Dictionary<string, List<CosmeticEquipment>> _cache = new Dictionary<string, List<CosmeticEquipment>>(StringComparer.OrdinalIgnoreCase);

        public static void StoreInCache(string key, List<CosmeticEquipment> equips)
        {
            if (string.IsNullOrWhiteSpace(key) || equips == null || equips.Count == 0)
                return;

            lock (_cache)
            {
                _cache[key.Trim().ToLower()] = equips;
            }
        }

        public static List<CosmeticEquipment> ParseEquips(string json)
        {
            if (string.IsNullOrWhiteSpace(json) || json == "null" || json == "undefined" || !json.Trim().StartsWith("{"))
                return new List<CosmeticEquipment>();

            try
            {
                Dictionary<string, CosmeticEquipment> items = JsonConvert.DeserializeObject<Dictionary<string, CosmeticEquipment>>(json);
                if (items == null)
                    return new List<CosmeticEquipment>();

                List<CosmeticEquipment> result = new List<CosmeticEquipment>();
                foreach (var kvp in items)
                {
                    if (kvp.Value == null) continue;
                    if (_backMap.TryGetValue(kvp.Key, out EquipType slot) && slot != EquipType.None)
                    {
                        kvp.Value.Slot = slot;
                        result.Add(kvp.Value);
                    }
                }
                return result;
            }
            catch
            {
                return new List<CosmeticEquipment>();
            }
        }

        public static List<CosmeticEquipment> Get(PlayerInfo player)
        {
            if (player != null)
                return Get(player.Name, player.EntID);
            return Get(null, -1);
        }

        public static List<CosmeticEquipment> Get(int id)
        {
            return Get(null, id);
        }

        public static List<CosmeticEquipment> Get(string username = null, int id = -1)
        {
            bool isMe = !string.IsNullOrEmpty(username) && username.Equals(Player.Username, StringComparison.OrdinalIgnoreCase);

            // 1. If grabbing self or nothing specified
            if (isMe || (string.IsNullOrEmpty(username) && id <= 0))
            {
                string myEqp = Flash.GetGameObject("world.myAvatar.objData.eqp");
                var list = ParseEquips(myEqp);
                if (list.Count > 0) return list;
            }

            // 2. Check cache (populated by HandlerCosmetics from initUserDatas packets)
            if (!string.IsNullOrEmpty(username))
            {
                lock (_cache)
                {
                    if (_cache.TryGetValue(username.Trim().ToLower(), out var cached) && cached.Count > 0)
                        return cached;
                }
            }

            if (id > 0)
            {
                lock (_cache)
                {
                    if (_cache.TryGetValue(id.ToString(), out var cached) && cached.Count > 0)
                        return cached;
                }
            }

            // 3. Check Flash world.uoTree (where AQW stores user data objects)
            if (!string.IsNullOrEmpty(username))
            {
                string lower = username.Trim().ToLower();

                try
                {
                    string uoEqp = Flash.GetGameObject($"world.uoTree.{lower}.eqp");
                    var list = ParseEquips(uoEqp);
                    if (list.Count > 0)
                    {
                        StoreInCache(username, list);
                        return list;
                    }
                }
                catch { }

                try
                {
                    string uoEqp = Flash.GetGameObject($"world.uoTree.{lower}.data.eqp");
                    var list = ParseEquips(uoEqp);
                    if (list.Count > 0)
                    {
                        StoreInCache(username, list);
                        return list;
                    }
                }
                catch { }

                try
                {
                    string uoEqp = Flash.GetGameObject($"world.uoTree.{lower}.objData.eqp");
                    var list = ParseEquips(uoEqp);
                    if (list.Count > 0)
                    {
                        StoreInCache(username, list);
                        return list;
                    }
                }
                catch { }
            }

            if (id > 0)
            {
                try
                {
                    string uoEqp = Flash.GetGameObject($"world.uoTree.{id}.eqp");
                    var list = ParseEquips(uoEqp);
                    if (list.Count > 0)
                    {
                        StoreInCache(id.ToString(), list);
                        if (!string.IsNullOrEmpty(username)) StoreInCache(username, list);
                        return list;
                    }
                }
                catch { }
            }

            // 4. Check if currently targeted player in-game matches
            try
            {
                string targetName = Flash.GetGameObject("world.myAvatar.target.dataLeaf.strUsername")?.Replace("\"", "").Trim();
                if (!string.IsNullOrEmpty(targetName) && !targetName.Equals("null", StringComparison.OrdinalIgnoreCase))
                {
                    if (string.IsNullOrEmpty(username) || targetName.Equals(username, StringComparison.OrdinalIgnoreCase))
                    {
                        string targetEqp = Flash.GetGameObject("world.myAvatar.target.objData.eqp");
                        var list = ParseEquips(targetEqp);
                        if (list.Count > 0)
                        {
                            if (!string.IsNullOrEmpty(username)) StoreInCache(username, list);
                            return list;
                        }
                    }
                }
            }
            catch { }

            // 5. If entID is known, request retrieveUserData from server and wait briefly for response
            if (id > 0)
            {
                try
                {
                    _ = Proxy.Instance.SendToServer($"%xt%zm%retrieveUserData%{World.RoomId}%{id}%");
                    System.Threading.Thread.Sleep(200);

                    lock (_cache)
                    {
                        if (_cache.TryGetValue(id.ToString(), out var cached) && cached.Count > 0)
                            return cached;
                        if (!string.IsNullOrEmpty(username) && _cache.TryGetValue(username.Trim().ToLower(), out cached) && cached.Count > 0)
                            return cached;
                    }
                }
                catch { }
            }

            return new List<CosmeticEquipment>();
        }
    }
}
using Grimoire.Botting;
using Grimoire.Game.Data;
using Grimoire.Tools;
using Grimoire.UI;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace Grimoire.Game
{
    public static class World
    {
        public static void RefreshDictionary()
        {
            try
            {
                string json = Flash.Call("Players", new object[0]);
                if (!string.IsNullOrEmpty(json) && json.StartsWith("{"))
                {
                    var dict = JsonConvert.DeserializeObject<Dictionary<string, PlayerInfo>>(json);
                    if (dict != null && dict.Count > 0)
                    {
                        _players = dict;
                        return;
                    }
                }
            }
            catch
            {
                // Ignore exceptions during deserialization to prevent UI thread crashes
            }

            try
            {
                var dict = new Dictionary<string, PlayerInfo>(StringComparer.OrdinalIgnoreCase);
                List<string> areaUsers = PlayersInMap;
                if (areaUsers != null)
                {
                    foreach (string unm in areaUsers)
                    {
                        if (!string.IsNullOrWhiteSpace(unm))
                            dict[unm.ToLower()] = new PlayerInfo { Name = unm.Trim() };
                    }
                }

                int avatarCount = 0;
                string lenStr = Flash.GetGameObject("world.avatars.length");
                if (int.TryParse(lenStr, out int l))
                    avatarCount = l;

                for (int i = 0; i < avatarCount; i++)
                {
                    try
                    {
                        string uName = Flash.GetGameObject($"world.avatars.{i}.dataLeaf.strUsername")?.Replace("\"", "").Trim();
                        if (!string.IsNullOrEmpty(uName) && !uName.Equals("null", StringComparison.OrdinalIgnoreCase) && !uName.Equals("undefined", StringComparison.OrdinalIgnoreCase))
                        {
                            int.TryParse(Flash.GetGameObject($"world.avatars.{i}.dataLeaf.entID"), out int eId);
                            string key = uName.ToLower();
                            if (dict.TryGetValue(key, out PlayerInfo existing))
                            {
                                if (eId > 0) existing.EntID = eId;
                            }
                            else
                            {
                                dict[key] = new PlayerInfo { Name = uName, EntID = eId };
                            }
                        }
                    }
                    catch { }
                }

                if (!string.IsNullOrEmpty(Player.Username))
                {
                    string myKey = Player.Username.ToLower();
                    if (dict.TryGetValue(myKey, out PlayerInfo myP))
                    {
                        if (myP.EntID <= 0 && Player.UserID > 0)
                            myP.EntID = Player.UserID;
                    }
                    else
                    {
                        dict[myKey] = new PlayerInfo
                        {
                            Name = Player.Username,
                            EntID = Player.UserID > 0 ? Player.UserID : 0
                        };
                    }
                }

                if (dict.Count > 0)
                {
                    _players = dict;
                }
            }
            catch { }
        }

        public static void UpdatePlayerFromData(string username, int uid, Newtonsoft.Json.Linq.JToken data)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username))
                    return;

                string key = username.Trim().ToLower();
                lock (_players)
                {
                    if (_players.TryGetValue(key, out PlayerInfo existing))
                    {
                        if (uid > 0) existing.EntID = uid;
                        if (data?["intLevel"] != null) existing.Level = (int?)data["intLevel"] ?? existing.Level;
                        if (data?["intHP"] != null) existing.HP = (int?)data["intHP"] ?? existing.HP;
                        if (data?["intHPMax"] != null) existing.MaxHP = (int?)data["intHPMax"] ?? existing.MaxHP;
                    }
                    else
                    {
                        _players[key] = new PlayerInfo
                        {
                            Name = username.Trim(),
                            EntID = uid,
                            Level = (int?)data?["intLevel"] ?? 0,
                            HP = (int?)data?["intHP"] ?? 0,
                            MaxHP = (int?)data?["intHPMax"] ?? 0
                        };
                    }
                }
            }
            catch { }
        }

        private static Dictionary<string, PlayerInfo> _players = new Dictionary<string, PlayerInfo>();
        /// <summary>
        /// Gets a list of all players in the current map.
        /// </summary>
        public static List<PlayerInfo> Players => _players != null ? _players.Values.ToList() : new List<PlayerInfo>();

        public static List<ShopInfo> LoadedShops;

        public static DropStack DropStack;

        private static readonly Dictionary<LockActions, string> LockedActions;

        public static List<Monster> VisibleMonsters => Flash.Call<List<Monster>>("GetVisibleMonstersInCell", new string[0]);


        private static List<Monster> _availableMonsters; //=> Flash.Call<List<Monster>>("GetMonstersInCell", Player.Cell);
        public static void refreshMonsters()
        {
            _availableMonsters = Flash.Call<List<Monster>>("GetMonstersInCell", Player.Cell);
        } //=> Flash.Call<List<Monster>>("GetMonstersInCell", Player.Cell);

        public static List<Monster> AvailableMonsters(bool refresh = true)
        {
            if (refresh)
                refreshMonsters();
            return _availableMonsters;
        }

        public static List<Monster> GetAllMonsters()
        {
            List<Monster> allMonsters = new List<Monster>();
            try
            {
                foreach (string cell in Cells)
                {
                    //Gets JSON as string from SWF
                    string json = Flash.Call("GetMonstersInCell", new object[] { cell });
                    if (!string.IsNullOrEmpty(json) && json.StartsWith("["))
                    {
                        //revert back to JSON
                        var monstersInCell = JsonConvert.DeserializeObject<List<Monster>>(json);
                        if (monstersInCell != null && monstersInCell.Count > 0)
                            allMonsters.AddRange(monstersInCell);
                        //else LogForm.Instance.AppendDebug($"[FAILED] Getting monsters on : {cell}");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"Please wait for map loaded or Login first before grabbing\n\n{ex.Message}",
                    "GrabAllMonsters Error",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
            }
            return allMonsters;
        }
        public static string GetMonsterNameHere()
        {
            return string.Join(" & ",
                AvailableMonsters()
                    .Select(m => m.Name)
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Distinct()
            );
        }

        public static List<string> GetMonsterCells(string monsterName)
        {
            List<Monster> monMap = GetAllMonsters();

            //1. Collect all monster, then ordered by most amount within a cell
            if (monsterName == "*")
                return monMap
                    .Where(m => !string.IsNullOrEmpty(m.cell))
                    .GroupBy(m => m.cell, StringComparer.OrdinalIgnoreCase)
                    .OrderByDescending(g => g.Count())
                    .Select(g => g.Key)
                    .ToList();

            string[] filterList = monsterName
                .Split('&')
                .Select(t => t.Trim())
                .Where(t => !string.IsNullOrEmpty(t))
                .ToArray();

            // 3. Filtering process
            List<Func<Monster, bool>> predicates = new List<Func<Monster, bool>>();
            foreach (string monName in filterList)
            {
                Match match = Regex.Match(monName, @"^id['.:-](?<Id>\d+)$", RegexOptions.IgnoreCase);
                if (match.Success && int.TryParse(match.Groups["Id"].Value, out int id))
                {
                    predicates.Add(m => m.MonMapID == id);
                }
                else
                {
                    predicates.Add(m =>
                        m.Name.ContainsIgnoreCase(monName)
                    );
                }
            }
            // 4. Combine with OR
            bool FinalPredicate(Monster m) => predicates.Any(p => p(m));

            // 5. Collect cells filtered with monster name/id
            return monMap
                .Where(FinalPredicate)
                .Where(m => !string.IsNullOrEmpty(m.cell))
                .GroupBy(m => m.cell, StringComparer.OrdinalIgnoreCase)
                .OrderByDescending(g => g.Count())
                .Select(g => g.Key)
                .ToList();
            /*List<string> targetCells = monMap
                .Where(finalPredicate)
                .GroupBy(m => m.cell, StringComparer.OrdinalIgnoreCase)
                .OrderByDescending(g => g.Count()) // cell with most monster 
                .Select(g => g.Key)
                .ToList();
            return targetCells;*/
        }

        public static void ReloadMap()
        {
            Flash.Call("ReloadMap", new string[0]);
        }
        public static void LoadMap(string mapSwf)
        {
            Flash.Call("LoadMap", mapSwf);
        }
        /// <summary>
        /// Checks if map already loaded, True = finished loading | False = load on progress
        /// </summary>
        public static bool IsMapLoading => !Flash.Call<bool>("MapLoadComplete", new string[0]);

        public static List<string> PlayersInMap => Flash.Call<List<string>>("PlayersInMap", new string[0]);

        public static List<InventoryItem> ItemTree => Flash.Call<List<InventoryItem>>("GetItemTree", new string[0]);

        public static string[] Cells => Flash.Call<string[]>("GetCells", new string[0]);

        /*public static string[] Cells { get {
                string cells = Flash.Call<string>("GetCells", new string[0]);
                return cells.Trim(new Char[] { ' ', '\"', '[', ']' }).Split(','); 
            } }*/

        public static int RoomId
        {
            get
            {
                try
                {
                    int rId = Flash.Call<int>("RoomId", new string[0]);
                    if (rId > 0) return rId;
                }
                catch { }

                try
                {
                    int curRoom = Flash.Instance.GetGameObject<int>("world.curRoom");
                    if (curRoom > 0) return curRoom;
                }
                catch { }

                try
                {
                    int activeRoomId = Flash.Instance.GetGameObject<int>("sfc.activeRoomId");
                    if (activeRoomId > 0) return activeRoomId;
                }
                catch { }

                return 0;
            }
        }

        public static int RoomNumber => Flash.Call<int>("RoomNumber", new string[0]);

        public static int GetPlayerHealthPercentage(string username) => Flash.Call<int>("GetPlayerHealthPercentage", username);

        public static int GetPlayerHealth(string username) => Flash.Call<int>("GetPlayerHealth", username);

        public static event Action<InventoryItem> ItemDropped;

        public static event Action<ShopInfo> ShopLoaded;

        public static void OnItemDropped(InventoryItem drop)
        {
            Action<InventoryItem> itemDropped = ItemDropped;
            if (itemDropped != null)
            {
                string text = $"{(Player.Inventory.GetItemByName(drop.Name) ?? new InventoryItem()).Quantity}";
                //LogForm.Instance.AppendDrops($"[Item Drop] {drop.Quantity} {drop.Name} at {DateTime.Now:hh:mm:ss tt} [{text}] \r\n");
                itemDropped(drop);
            }

            //ItemDropped?.Invoke(drop);
        }

        public static void OnShopLoaded(ShopInfo shopInfo)
        {
            ShopLoaded?.Invoke(shopInfo);
            if (!LoadedShops.Exists(s => s.Id == shopInfo.Id))
            {
                LoadedShops.Add(shopInfo);
            }
        }

        public static bool IsActionAvailable(LockActions action) => Flash.Call<bool>("IsActionAvailable", LockedActions[action]);

        public static void SetSpawnPoint() => Flash.Call("SetSpawnPoint", new string[0]);

        public static int GetMonsterHealth(string monster) => Flash.Call<int>("GetMonsterHealth", new string[] { monster });

        public static bool IsMonsterAvailable(string name)
        {
            if (name.StartsWith("id'"))
            {
                return Flash.Call<bool>("IsMonsterAvailableByMonMapID", new string[1] { name.Split('\'')[1] });
            }
            else if (name.StartsWith("id."))
            {
                return Flash.Call<bool>("IsMonsterAvailableByMonMapID", new string[1] { name.Split('.')[1] });
            }
            else if (name.StartsWith("id:"))
            {
                return Flash.Call<bool>("IsMonsterAvailableByMonMapID", new string[1] { name.Split(':')[1] });
            }
            else if (name.StartsWith("id-"))
            {
                return Flash.Call<bool>("IsMonsterAvailableByMonMapID", new string[1] { name.Split('-')[1] });
            }
            else
            {
                return Flash.Call<bool>("IsMonsterAvailable", new string[1] { name });
            }
        }

        public static bool MonstersAvailable(string[] monsters, out string monster)
        {
            monster = null;

            if (monsters == null || monsters.Length == 0)
                return false;

            foreach (string m in monsters)
            {
                if (!string.IsNullOrWhiteSpace(m) && World.IsMonsterAvailable(m))
                {
                    monster = m;
                    return true;
                }
            }
            return false;
        }
        public static string realmap;
        public static void spoofMap(dynamic data = null, bool revert = false)
        {
            if (revert)
            {
                Flash.SetGameObject("world.strAreaName", realmap);
                //realmap = "";
                Flash.CallGameFunction2("updateAreaName", new string[0]);
                return;
            }
            //_realmap = data != null ? data.areaName : Player.Map;
            //Console.WriteLine("saved realmap name : " + realmap);
            string spoof = BotManager.Instance.tbMapSpoof.Text;
            Flash.SetGameObject("world.strAreaName", spoof);
            if (data != null && data.strMapName == "house")
                Flash.SetGameObject("world.objHouseData.unm", spoof);
            Flash.CallGameFunction2("updateAreaName", new string[0]);
        }
        public static void UpdateAreaName(
            string mapname,
            string customHexColor = null,
            string fullCustom = null)
        {

            string areaText;
            int.TryParse(
                Flash.GetGameObject("world.areaUsers.length"),
                out int playerCount
            );
            //playerCount--;



            // default Colour
            string[] defCol = { "#FFFFFF", "#FFFF00" };
            //1 Player(s) in Mapname-Number
            string playerText = $"{playerCount} player{(playerCount > 1 ? "(s)" : "")}";
            areaText =
                $"<font color='#{defCol[0]}'>{playerText}</font> " + $"in " +
                $"<font color='#{defCol[1]}'>{mapname}</font>";

            string[] color = customHexColor.Split(',');
            if (!string.IsNullOrEmpty(customHexColor))
                areaText = areaText.Replace($"{defCol[0]}", color[0])
                                   .Replace($"{defCol[1]}", color[1]);


            Flash.SetGameObject(
                "ui.mcInterface.areaList.title.t1.htmlText",
                areaText
            );
        }

        static World()
        {
            LoadedShops = new List<ShopInfo>();
            DropStack = new DropStack();
            LockedActions = new Dictionary<LockActions, string>(14)
            {
                {
                    LockActions.LoadShop,
                    "loadShop"
                },
                {
                    LockActions.LoadEnhShop,
                    "loadEnhShop"
                },
                {
                    LockActions.LoadHairShop,
                    "loadHairShop"
                },
                {
                    LockActions.EquipItem,
                    "equipItem"
                },
                {
                    LockActions.UnequipItem,
                    "unequipItem"
                },
                {
                    LockActions.BuyItem,
                    "buyItem"
                },
                {
                    LockActions.SellItem,
                    "sellItem"
                },
                {
                    LockActions.GetMapItem,
                    "getMapItem"
                },
                {
                    LockActions.TryQuestComplete,
                    "tryQuestComplete"
                },
                {
                    LockActions.AcceptQuest,
                    "acceptQuest"
                },
                {
                    LockActions.DoIA,
                    "doIA"
                },
                {
                    LockActions.Rest,
                    "rest"
                },
                {
                    LockActions.Who,
                    "who"
                },
                {
                    LockActions.Transfer,
                    "tfer"
                }
            };
        }
    }
}
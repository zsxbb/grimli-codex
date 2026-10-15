using DarkUI.Forms;
using Grimoire.Botting;
using Grimoire.Game;
using Grimoire.Tools;
using Grimoire.Utils;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Windows.Forms;

namespace Grimoire.UI
{
    public partial class CosmeticForm : DarkForm
    {
        public static CosmeticForm Instance
        {
            get;
        } = new CosmeticForm();

        public CosmeticForm()
        {
            InitializeComponent();
            lbItems.SelectionMode = SelectionMode.MultiExtended;

            txtHelm1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtHelm1, txtHelm2);
            txtArmor1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtArmor1, txtArmor2);
            txtClass1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtClass1, txtClass2);
            txtWeapon1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtWeapon1, txtWeapon2);
            txtPet1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtPet1, txtPet2);
            txtCape1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtCape1, txtCape2);
            txtOff1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtOff1, txtOff2);
            txtMisc1.TextChanged += (s, e) => AutoFillLinkFromTextBox(txtMisc1, txtMisc2);

            this.VisibleChanged += (s, e) =>
            {
                if (this.Visible)
                    RefreshPlayers();
            };
            cbPlayer.DropDown += (s, e) => RefreshPlayers();
        }

        private PlayerInfo GetSelectedPlayer()
        {
            if (cbPlayer.SelectedItem is PlayerInfo pi && !string.IsNullOrWhiteSpace(pi.Name))
                return pi;

            string txt = cbPlayer.Text?.Trim();
            if (!string.IsNullOrEmpty(txt))
            {
                int entId = 0;
                string name = txt;
                if (txt.Contains(":"))
                {
                    string[] parts = txt.Split(':');
                    int.TryParse(parts[0].Trim(), out entId);
                    name = parts[1].Trim();
                }

                return new PlayerInfo { Name = name, EntID = entId };
            }

            return null;
        }

        public void RefreshPlayers()
        {
            if (!Player.IsLoggedIn)
                return;

            string prevSelectedName = null;
            if (cbPlayer.SelectedItem is PlayerInfo pi && !string.IsNullOrWhiteSpace(pi.Name))
                prevSelectedName = pi.Name;
            else if (!string.IsNullOrWhiteSpace(cbPlayer.Text))
            {
                string txt = cbPlayer.Text.Trim();
                if (txt.Contains(":"))
                    txt = txt.Substring(txt.IndexOf(':') + 1).Trim();
                prevSelectedName = txt;
            }

            Dictionary<string, PlayerInfo> playersMap = new Dictionary<string, PlayerInfo>(StringComparer.OrdinalIgnoreCase);

            // 1. Try World.PlayersInMap (areaUsers in Flash - always returns room players)
            try
            {
                List<string> areaUsers = World.PlayersInMap;
                if (areaUsers != null)
                {
                    foreach (string user in areaUsers)
                    {
                        if (!string.IsNullOrWhiteSpace(user) && !playersMap.ContainsKey(user))
                        {
                            playersMap[user] = new PlayerInfo { Name = user.Trim(), EntID = 0 };
                        }
                    }
                }
            }
            catch { }

            // 2. Query world.avatars array (to enrich with entID and find cell avatars)
            try
            {
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
                            if (playersMap.TryGetValue(uName, out PlayerInfo existing))
                            {
                                if (eId > 0) existing.EntID = eId;
                            }
                            else
                            {
                                playersMap[uName] = new PlayerInfo { Name = uName, EntID = eId };
                            }
                        }
                    }
                    catch { }
                }
            }
            catch { }

            // 3. Try World.RefreshDictionary / World.Players
            try
            {
                World.RefreshDictionary();
                var worldPlayers = World.Players;
                if (worldPlayers != null)
                {
                    foreach (var p in worldPlayers)
                    {
                        if (p != null && !string.IsNullOrWhiteSpace(p.Name))
                        {
                            if (playersMap.TryGetValue(p.Name, out PlayerInfo existing))
                            {
                                if (existing.EntID <= 0 && p.EntID > 0) existing.EntID = p.EntID;
                            }
                            else
                            {
                                playersMap[p.Name] = p;
                            }
                        }
                    }
                }
            }
            catch { }

            // 4. Ensure current player is included
            if (!string.IsNullOrEmpty(Player.Username))
            {
                if (playersMap.TryGetValue(Player.Username, out PlayerInfo myP))
                {
                    if (myP.EntID <= 0 && Player.UserID > 0)
                        myP.EntID = Player.UserID;
                }
                else
                {
                    playersMap[Player.Username] = new PlayerInfo
                    {
                        Name = Player.Username,
                        EntID = Player.UserID > 0 ? Player.UserID : 0
                    };
                }
            }

            // 5. Ensure targeted player is included
            try
            {
                string targetName = Flash.GetGameObject("world.myAvatar.target.dataLeaf.strUsername")?.Replace("\"", "").Trim();
                if (!string.IsNullOrEmpty(targetName) && !targetName.Equals("null", StringComparison.OrdinalIgnoreCase) && !targetName.Equals("undefined", StringComparison.OrdinalIgnoreCase))
                {
                    int.TryParse(Flash.GetGameObject("world.myAvatar.target.dataLeaf.entID"), out int targetEntID);
                    if (playersMap.TryGetValue(targetName, out PlayerInfo targetP))
                    {
                        if (targetP.EntID <= 0 && targetEntID > 0) targetP.EntID = targetEntID;
                    }
                    else
                    {
                        playersMap[targetName] = new PlayerInfo { Name = targetName, EntID = targetEntID };
                    }
                }
            }
            catch { }

            cbPlayer.BeginUpdate();
            try
            {
                cbPlayer.Items.Clear();

                string currentUsername = Player.Username ?? "";
                string currentTarget = "";
                try
                {
                    currentTarget = Flash.GetGameObject("world.myAvatar.target.dataLeaf.strUsername")?.Replace("\"", "").Trim() ?? "";
                }
                catch { }

                var sortedList = playersMap.Values
                    .OrderByDescending(p => p.Name.Equals(currentUsername, StringComparison.OrdinalIgnoreCase))
                    .ThenByDescending(p => !string.IsNullOrEmpty(currentTarget) && p.Name.Equals(currentTarget, StringComparison.OrdinalIgnoreCase))
                    .ThenBy(p => p.Name, StringComparer.OrdinalIgnoreCase)
                    .ToList();

                if (sortedList.Count > 0)
                {
                    cbPlayer.Items.AddRange(sortedList.ToArray());

                    int selectIdx = -1;
                    if (!string.IsNullOrEmpty(prevSelectedName))
                    {
                        selectIdx = sortedList.FindIndex(p => p.Name.Equals(prevSelectedName, StringComparison.OrdinalIgnoreCase));
                    }

                    if (selectIdx == -1 && !string.IsNullOrEmpty(currentTarget))
                    {
                        selectIdx = sortedList.FindIndex(p => p.Name.Equals(currentTarget, StringComparison.OrdinalIgnoreCase));
                    }

                    if (selectIdx == -1 && !string.IsNullOrEmpty(currentUsername))
                    {
                        selectIdx = sortedList.FindIndex(p => p.Name.Equals(currentUsername, StringComparison.OrdinalIgnoreCase));
                    }

                    cbPlayer.SelectedIndex = selectIdx > -1 ? selectIdx : 0;
                }
            }
            finally
            {
                cbPlayer.EndUpdate();
            }
        }

        private void lnkRefresh_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            RefreshPlayers();
        }

        private void btnGrabCosm_Click(object sender, EventArgs e)
        {
            PlayerInfo player = GetSelectedPlayer();
            if (player == null)
            {
                RefreshPlayers();
                player = GetSelectedPlayer();
            }

            List<CosmeticEquipment> equips = CosmeticEquipment.Get(player);
            if (equips != null && equips.Count > 0)
            {
                try
                {
                    if (lbItems.Items.Count > 0 && lbItems.Items[lbItems.Items.Count - 1].ToString() != " ")
                        lbItems.Items.Add(" ");
                }
                catch { }

                lbItems.Items.AddRange(equips.ToArray());
                lbItems.Items.Add(" ");

                txtHelm1.Text = ""; txtHelm2.Text = "";
                txtArmor1.Text = ""; txtArmor2.Text = "";
                txtClass1.Text = ""; txtClass2.Text = "";
                txtWeapon1.Text = ""; txtWeapon2.Text = "";
                txtOff1.Text = ""; txtOff2.Text = "";
                txtPet1.Text = ""; txtPet2.Text = "";
                txtCape1.Text = ""; txtCape2.Text = "";
                txtMisc1.Text = ""; txtMisc2.Text = "";

                foreach (var eq in equips)
                {
                    switch (eq.Slot)
                    {
                        case EquipType.Helm:
                            txtHelm1.Text = eq.SWFFile;
                            txtHelm2.Text = eq.Link;
                            break;
                        case EquipType.Armor:
                            txtArmor1.Text = eq.SWFFile;
                            txtArmor2.Text = eq.Link;
                            break;
                        case EquipType.Class:
                            txtClass1.Text = eq.SWFFile;
                            txtClass2.Text = eq.Link;
                            break;
                        case EquipType.Weapon:
                            txtWeapon1.Text = eq.SWFFile;
                            txtWeapon2.Text = eq.Link;
                            break;
                        case EquipType.Offhand:
                            txtOff1.Text = eq.SWFFile;
                            txtOff2.Text = eq.Link;
                            break;
                        case EquipType.Pet:
                            txtPet1.Text = eq.SWFFile;
                            txtPet2.Text = eq.Link;
                            break;
                        case EquipType.Cape:
                            txtCape1.Text = eq.SWFFile;
                            txtCape2.Text = eq.Link;
                            break;
                        case EquipType.Ground:
                            txtMisc1.Text = eq.SWFFile;
                            txtMisc2.Text = eq.Link;
                            break;
                    }
                }
            }
            else
            {
                string targetName = player?.Name ?? cbPlayer.Text;
                lbItems.Items.Add($"[Notice] Data for {targetName} not received yet. Target them in-game or wait a moment and click Grab again.");
            }
        }

        private void btnCopyAll_Click(object sender, EventArgs e)
        {
            try
            {
                lbItems.Items.OfType<CosmeticEquipment>().ForEach(x => x.Equip());
            }
            catch { }
        }

        private void btnEquipSelected_Click(object sender, EventArgs e)
        {
            try
            {
                lbItems.SelectedItems.OfType<CosmeticEquipment>().ForEach(x => x.Equip());
            }
            catch { }
        }

        private void CosmeticForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            RefreshPlayers();
        }

        private void btnClear_Click(object sender, EventArgs e)
        {
            lbItems.Items.Clear();
            TextBox[] textboxes = new TextBox[]
            {
                txtHelm1,
                txtHelm2,
                txtArmor1,
                txtArmor2,
                txtClass1,
                txtClass2,
                txtWeapon1,
                txtWeapon2,
                txtPet1,
                txtPet2,
                txtCape1,
                txtCape2,
                txtOff1,
                txtOff2,
                txtMisc1,
                txtMisc2
            };
            foreach (TextBox tb in textboxes)
                tb.Text = "";
        }

        private void linkItems_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            PlayerInfo player = GetSelectedPlayer();
            if (player == null)
            {
                RefreshPlayers();
                player = GetSelectedPlayer();
            }

            List<CosmeticEquipment> equips = CosmeticEquipment.Get(player);
            if (equips == null || equips.Count == 0)
                return;

            string lbl = ((LinkLabel)sender).Text.Split(' ')[1].Replace("Wep", "Weapon");
            object[] array = equips.ToArray();
            for (int num = 0; array.Length > num; num++)
            {
                if (array[num].ToString().StartsWith(lbl))
                {
                    lbItems.Items.Add(array[num]);
                    string[] i = array[num].ToString().Replace($"{lbl}: ", "").Split(';');
                    if (lbl == "Cape")
                    {
                        txtCape1.Text = i[0];
                        txtCape2.Text = i[1];
                    }
                    else if (lbl == "Class")
                    {
                        txtClass1.Text = i[0];
                        txtClass2.Text = i[1];
                    }
                    else if (lbl == "Pet")
                    {
                        txtPet1.Text = i[0];
                        txtPet2.Text = i[1];
                    }
                    else if (lbl == "Weapon")
                    {
                        txtWeapon1.Text = i[0];
                        txtWeapon2.Text = i[1];
                    }
                    else if (lbl == "Helm")
                    {
                        txtHelm1.Text = i[0];
                        txtHelm2.Text = i[1];
                    }
                    else if (lbl == "Armor")
                    {
                        txtArmor1.Text = i[0];
                        txtArmor2.Text = i[1];
                    }
                    else if (lbl == "Ground")
                    {
                        txtMisc1.Text = i[0];
                        txtMisc2.Text = i[1];
                    }
                }
            }
        }

        private void lbItems_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (lbItems.SelectedItem != null)
                {
                    int selectedIndex = lbItems.SelectedIndex;
                    if (selectedIndex > -1)
                    {
                        for (int x = lbItems.SelectedIndices.Count - 1; x >= 0; x--)
                        {
                            int idx = lbItems.SelectedIndices[x];
                            lbItems.Items.RemoveAt(idx);
                        }
                        lbItems.EndUpdate();
                    }
                }
            }
            if (e.KeyCode == Keys.Enter && lbItems.SelectedIndex > -1)
            {
                var selectedItems = lbItems.SelectedItems;
                for(int num = 0; selectedItems.Count > num; num++)
                {
                    string lbl = selectedItems[num].ToString().Split(':')[0];
                    if (selectedItems[num].ToString() == " ")
                        continue;
                    var i = selectedItems[num].ToString().Replace($"{lbl}: ", "").Split(';');
                    switch (lbl)
                    {
                        case "Cape":
                            txtCape1.Text = i[0];
                            txtCape2.Text = i[1];
                            break;

                        case "Pet":
                            txtPet1.Text = i[0];
                            txtPet2.Text = i[1];
                            break;

                        case "Class":
                            txtClass1.Text = i[0];
                            txtClass2.Text = i[1];
                            break;

                        case "Helm":
                            txtHelm1.Text = i[0];
                            txtHelm2.Text = i[1];
                            break;

                        case "Armor":
                            txtArmor1.Text = i[0];
                            txtArmor2.Text = i[1];
                            break;

                        case "Ground":
                            txtMisc1.Text = i[0];
                            txtMisc2.Text = i[1];
                            break;

                        default:
                            txtWeapon1.Text = i[0];
                            txtWeapon2.Text = i[1];
                            break;
                    }
                }
            }
        }

        private void btnSet_Click(object sender, EventArgs e)
        {
            Button s = (Button)sender;
            string txt = s.Name.Replace("btn", "").Replace("Set", "");
            string file;
            string link;
            switch (txt)
            {
                case "Cape":
                    txt = "ba";
                    file = txtCape1.Text;
                    link = txtCape2.Text;
                    break;

                case "Class":
                    txt = "ar";
                    file = txtClass1.Text;
                    link = txtClass2.Text;
                    break;

                case "Pet":
                    txt = "pe";
                    file = txtPet1.Text;
                    link = txtPet2.Text;
                    break;

                case "Helm":
                    txt = "he";
                    file = txtHelm1.Text;
                    link = txtHelm2.Text;
                    break;

                case "Armor":
                    txt = "co";
                    file = txtArmor1.Text;
                    link = txtArmor2.Text;
                    break;

                case "Offhand":
                    txt = "Off";
                    file = txtOff1.Text;
                    link = txtOff2.Text;
                    break;

                case "Ground":
                    txt = "mi";
                    file = txtMisc1.Text;
                    link = txtMisc2.Text;
                    break;

                default:
                    txt = "Weapon";
                    file = txtWeapon1.Text;
                    link = txtWeapon2.Text;
                    break;
            }
            dynamic equip = new ExpandoObject();
            equip.sFile = file;
            equip.sLink = link.ReplaceLink();
            equip.sType = txt;
            //equip.sMeta = Meta;
            Flash.Call("SetEquip", new object[2] { txt , equip });
        }

        private void btnSaveSet_Click(object sender, EventArgs e)
        {
            string[] _data = new string[24]
            {
               "Helmet:",
               $"he file:{txtHelm1.Text ?? "None"}",
               $"he link:{txtHelm2.Text ?? "None"}",
               "\r\nArmor:",
               $"co file:{txtArmor1.Text ?? "None"}",
               $"co link:{txtArmor2.Text ?? "None"}",
               "\r\nClass:",
               $"ar file:{txtClass1.Text ?? "None"}",
               $"ar link:{txtClass2.Text ?? "None"}",
               "\r\nWeapon:",
               $"Weapon file:{txtWeapon1.Text ?? "None"}",
               $"Weapon link:{txtWeapon2.Text ?? "None"}",
               "\r\nPet:",
               $"pe file:{txtPet1.Text ?? "None"}",
               $"pe link:{txtPet2.Text ?? "None"}",
               "\r\nCape:",
               $"ba file:{txtCape1.Text ?? "None"}",
               $"ba link:{txtCape2.Text ?? "None"}",
               "\r\nOff:",
               $"off file:{txtOff1.Text ?? "None"}",
               $"off link:{txtOff2.Text ?? "None"}",
               "\r\nGround:",
               $"mi file:{txtMisc1.Text ?? "None"}",
               $"mi link:{txtMisc2.Text ?? "None"}"
            };
            SaveFileDialog saveFileDialog = new SaveFileDialog()
            {
                InitialDirectory = Application.StartupPath + "\\Sets",
                Filter = "Grimoire sets|*.gset"
            };
            if (saveFileDialog.ShowDialog() == DialogResult.OK)
                File.WriteAllLines(saveFileDialog.FileName, _data);
        }

        private void btnLoadSet_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog()
            {
                InitialDirectory = Application.StartupPath + "\\Sets",
                Filter = "Grimoire sets|*.gset"
            };
            if(openFileDialog.ShowDialog() == DialogResult.OK)
            {
                string[] s = File.ReadAllLines(openFileDialog.FileName).Where(empty => empty.Trim() != string.Empty).ToArray();
                try
                {
                    txtHelm1.Text = s[1].Split(':')[1];
                    txtHelm2.Text = s[2].Split(':')[1];
                    txtArmor1.Text = s[4].Split(':')[1];
                    txtArmor2.Text = s[5].Split(':')[1];
                    txtClass1.Text = s[7].Split(':')[1];
                    txtClass2.Text = s[8].Split(':')[1];
                    txtWeapon1.Text = s[10].Split(':')[1];
                    txtWeapon2.Text = s[11].Split(':')[1];
                    txtPet1.Text = s[13].Split(':')[1];
                    txtPet2.Text = s[14].Split(':')[1];
                    txtCape1.Text = s[16].Split(':')[1];
                    txtCape2.Text = s[17].Split(':')[1];
                    txtOff1.Text = s[19].Split(':')[1];
                    txtOff2.Text = s[20].Split(':')[1];
                    txtMisc1.Text = s[22].Split(':')[1];
                    txtMisc2.Text = s[23].Split(':')[1];
                }
                catch { }
            }
        }

        private void lbItems_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            if (lbItems.SelectedItem.ToString() == " ")
                return;
            string lbl = lbItems.SelectedItem.ToString().Split(':')[0];
            string[] i = lbItems.SelectedItem.ToString().Replace($"{lbl}: ", "").Split(';');
            switch(lbl)
            {
                case "Cape":
                    txtCape1.Text = i[0];
                    txtCape2.Text = i[1];
                    break;

                case "Pet":
                    txtPet1.Text = i[0];
                    txtPet2.Text = i[1];
                    break;

                case "Class":
                    txtClass1.Text = i[0];
                    txtClass2.Text = i[1];
                    break;

                case "Helm":
                    txtHelm1.Text = i[0];
                    txtHelm2.Text = i[1];
                    break;

                case "Armor":
                    txtArmor1.Text = i[0];
                    txtArmor2.Text = i[1];
                    break;

                case "Ground":
                    txtMisc1.Text = i[0];
                    txtMisc2.Text = i[1];
                    break;

                default:
                    txtWeapon1.Text = i[0];
                    txtWeapon2.Text = i[1];
                    break;
            }
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            try
            {
                var selectedItems = lbItems.SelectedIndices;
                for(int x = selectedItems.Count - 1; x >= 0; x--)
                {
                    int idx = selectedItems[x];
                    lbItems.Items.RemoveAt(idx);
                }
            }
            catch
            {

            }
        }

        private void btnQuickEquip_Click(object sender, EventArgs e)
        {
            QuickEquipFromUrl(txtQuickLink.Text);
        }

        private void txtQuickLink_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true;
                QuickEquipFromUrl(txtQuickLink.Text);
            }
        }

        public void QuickEquipFromUrl(string url)
        {
            if (string.IsNullOrWhiteSpace(url))
                return;

            url = url.Trim();

            string file = url;
            if (file.StartsWith("https://game.aq.com/game/gamefiles/", StringComparison.OrdinalIgnoreCase))
                file = file.Substring("https://game.aq.com/game/gamefiles/".Length);
            else if (file.StartsWith("http://game.aq.com/game/gamefiles/", StringComparison.OrdinalIgnoreCase))
                file = file.Substring("http://game.aq.com/game/gamefiles/".Length);

            string fileName = url;
            int lastSlash = url.LastIndexOf('/');
            if (lastSlash >= 0 && lastSlash < url.Length - 1)
                fileName = url.Substring(lastSlash + 1);

            int queryIdx = fileName.IndexOf('?');
            if (queryIdx >= 0)
                fileName = fileName.Substring(0, queryIdx);

            string link = fileName.Replace(".swf", "").Replace("_skin", "");

            string lowerUrl = url.ToLowerInvariant();
            string slot;
            TextBox txt1, txt2;

            if (lowerUrl.Contains("/daggers/") || lowerUrl.Contains("dagger") || lowerUrl.Contains("dual"))
            {
                txtWeapon1.Text = file;
                txtWeapon2.Text = link;
                txtOff1.Text = file;
                txtOff2.Text = link;

                dynamic equipWeapon = new ExpandoObject();
                equipWeapon.sFile = file;
                equipWeapon.sLink = link.ReplaceLink();
                equipWeapon.sType = "Weapon";
                Flash.Call("SetEquip", new object[2] { "Weapon", equipWeapon });

                dynamic equipOff = new ExpandoObject();
                equipOff.sFile = file;
                equipOff.sLink = link.ReplaceLink();
                equipOff.sType = "Off";
                Flash.Call("SetEquip", new object[2] { "Off", equipOff });
                return;
            }

            if (lowerUrl.Contains("/helm") || lowerUrl.Contains("/hair"))
            {
                slot = "he";
                txt1 = txtHelm1;
                txt2 = txtHelm2;
            }
            else if (lowerUrl.Contains("/armor") || lowerUrl.Contains("/costume"))
            {
                slot = "co";
                txt1 = txtArmor1;
                txt2 = txtArmor2;
            }
            else if (lowerUrl.Contains("/class"))
            {
                slot = "ar";
                txt1 = txtClass1;
                txt2 = txtClass2;
            }
            else if (lowerUrl.Contains("/cape") || lowerUrl.Contains("/back"))
            {
                slot = "ba";
                txt1 = txtCape1;
                txt2 = txtCape2;
            }
            else if (lowerUrl.Contains("/pet"))
            {
                slot = "pe";
                txt1 = txtPet1;
                txt2 = txtPet2;
            }
            else if (lowerUrl.Contains("/ground") || lowerUrl.Contains("/misc"))
            {
                slot = "mi";
                txt1 = txtMisc1;
                txt2 = txtMisc2;
            }
            else
            {
                slot = "Weapon";
                txt1 = txtWeapon1;
                txt2 = txtWeapon2;
            }

            if (txt1 != null) txt1.Text = file;
            if (txt2 != null) txt2.Text = link;

            dynamic equip = new ExpandoObject();
            equip.sFile = file;
            equip.sLink = link.ReplaceLink();
            equip.sType = slot;
            Flash.Call("SetEquip", new object[2] { slot, equip });
        }

        private void AutoFillLinkFromTextBox(TextBox fileBox, TextBox linkBox)
        {
            string url = fileBox.Text.Trim();
            if (string.IsNullOrEmpty(url)) return;

            string file = url;
            if (file.StartsWith("https://game.aq.com/game/gamefiles/", StringComparison.OrdinalIgnoreCase))
            {
                file = file.Substring("https://game.aq.com/game/gamefiles/".Length);
                fileBox.Text = file;
            }
            else if (file.StartsWith("http://game.aq.com/game/gamefiles/", StringComparison.OrdinalIgnoreCase))
            {
                file = file.Substring("http://game.aq.com/game/gamefiles/".Length);
                fileBox.Text = file;
            }

            if (file.EndsWith(".swf", StringComparison.OrdinalIgnoreCase) || file.Contains("/"))
            {
                string fileName = file;
                int lastSlash = file.LastIndexOf('/');
                if (lastSlash >= 0 && lastSlash < file.Length - 1)
                    fileName = file.Substring(lastSlash + 1);

                int queryIdx = fileName.IndexOf('?');
                if (queryIdx >= 0)
                    fileName = fileName.Substring(0, queryIdx);

                string link = fileName.Replace(".swf", "").Replace("_skin", "");
                if (!string.IsNullOrEmpty(link))
                {
                    linkBox.Text = link;
                }

                if (fileBox == txtWeapon1 && (file.ToLowerInvariant().Contains("/daggers/") || file.ToLowerInvariant().Contains("dagger") || file.ToLowerInvariant().Contains("dual")))
                {
                    txtOff1.Text = file;
                    txtOff2.Text = link;
                }
            }
        }
	}
}
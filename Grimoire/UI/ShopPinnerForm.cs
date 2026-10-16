using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Botting;
using Grimoire.Game;
using Grimoire.Game.Data;
using Grimoire.Tools;
using Grimoire.Networking;
using Newtonsoft.Json;

namespace Grimoire.UI
{
    public partial class ShopPinnerForm : DarkForm
    {
        public static ShopPinnerForm Instance { get; } = new ShopPinnerForm();

        private readonly string filePath = Path.Combine(Application.StartupPath, "PinnedShops.json");

        private List<PinnedShop> pinnedShops = new List<PinnedShop>();

        public class PinnedShop
        {
            public int Id { get; set; }
            public string Map { get; set; }
            public string Name { get; set; }

            public override string ToString()
            {
                string mapTag = string.IsNullOrWhiteSpace(Map) ? "" : $"{Map} - ";
                string title = string.IsNullOrEmpty(Name) ? $"Shop {Id}" : Name;
                return $"{Id} - {mapTag}{title}";
            }
        }

        private ShopPinnerForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private void ShopPinnerForm_Load(object sender, EventArgs e)
        {
            LoadPinnedShops();
        }

        private void ShopPinnerForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }

        private void LoadPinnedShops()
        {
            try
            {
                if (File.Exists(filePath))
                {
                    string json = File.ReadAllText(filePath);
                    pinnedShops = JsonConvert.DeserializeObject<List<PinnedShop>>(json) ?? new List<PinnedShop>();
                }
                else
                {
                    // Default shop list with required Map and Shop ID
                    pinnedShops = new List<PinnedShop>
                    {
                        new PinnedShop { Id = 2114, Map = "alchemyacademy", Name = "Jera Shop" },
                        new PinnedShop { Id = 2115, Map = "alchemyacademy", Name = "Uruz Shop" },
                        new PinnedShop { Id = 2036, Map = "alchemyacademy", Name = "Gebo Shop" },
                        new PinnedShop { Id = 2116, Map = "alchemyacademy", Name = "Febu Shop" },
                        new PinnedShop { Id = 1951, Map = "tercessuinotlim", Name = "Swindle Merge" }
                    };
                    SavePinnedShops();
                }
            }
            catch
            {
                pinnedShops = new List<PinnedShop>();
            }

            UpdateList();
        }

        private void SavePinnedShops()
        {
            try
            {
                string json = JsonConvert.SerializeObject(pinnedShops, Formatting.Indented);
                File.WriteAllText(filePath, json);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Failed to save pinned shops: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void UpdateList()
        {
            lstShops.Items.Clear();
            foreach (var shop in pinnedShops)
            {
                lstShops.Items.Add(shop);
            }
        }

        private void btnAddShop_Click(object sender, EventArgs e)
        {
            int shopId = (int)numShopId.Value;
            string map = tbMap.Text.Trim();
            string name = tbShopName.Text.Trim();

            if (shopId <= 0)
            {
                MessageBox.Show("Please enter a valid Shop ID.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (pinnedShops.Any(s => s.Id == shopId && string.Equals(s.Map, map, StringComparison.OrdinalIgnoreCase)))
            {
                MessageBox.Show("This Shop is already pinned.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            pinnedShops.Add(new PinnedShop { Id = shopId, Map = map, Name = name });
            UpdateList();

            // Clear inputs
            numShopId.Value = 0;
            tbMap.Text = "";
            tbShopName.Text = "";
        }

        private void btnRemoveShop_Click(object sender, EventArgs e)
        {
            var selectedShops = lstShops.SelectedItems.Cast<PinnedShop>().ToList();
            if (selectedShops.Count > 0)
            {
                foreach (var selected in selectedShops)
                {
                    pinnedShops.Remove(selected);
                }
                UpdateList();
            }
            else
            {
                MessageBox.Show("Please select a shop to remove.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private async void btnLoadSelected_Click(object sender, EventArgs e)
        {
            if (!Player.IsLoggedIn)
            {
                MessageBox.Show("Please log in first.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            var selectedShop = lstShops.SelectedItem as PinnedShop;
            if (selectedShop != null)
            {
                await LoadShopSafely(selectedShop);
            }
            else
            {
                MessageBox.Show("Please select a shop to load.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private async void lstShops_DoubleClick(object sender, EventArgs e)
        {
            if (!Player.IsLoggedIn)
                return;

            var selectedShop = lstShops.SelectedItem as PinnedShop;
            if (selectedShop != null)
            {
                await LoadShopSafely(selectedShop);
            }
        }

        private async Task LoadShopSafely(PinnedShop shop)
        {
            try
            {
                if (!Player.IsLoggedIn || shop == null) return;

                // 1. Jika nama map ditentukan dan karakter belum berada di map tersebut, /join ke map dulu
                if (!string.IsNullOrWhiteSpace(shop.Map) && !Player.Map.EqualsIgnoreCase(shop.Map.Trim()))
                {
                    // Keluar combat jika perlu
                    if (Player.CurrentState == Player.State.InCombat)
                    {
                        await Player.ExitCombat(1000);
                    }

                    Player.JoinMap(shop.Map.Trim(), "Enter", "Spawn");

                    // Tunggu hingga karakter masuk ke map dan map selesai loading (timeout max ~12s)
                    int waitMap = 0;
                    while ((!Player.Map.EqualsIgnoreCase(shop.Map.Trim()) || World.IsMapLoading) && waitMap < 60)
                    {
                        await Task.Delay(200);
                        waitMap++;
                    }

                    await Task.Delay(800); // Waktu stabilisasi setelah tiba di map
                }

                // 2. Pastikan sudah keluar dari combat sebelum membuka shop
                if (Player.CurrentState == Player.State.InCombat)
                {
                    await Player.ExitCombat(1000);
                }

                // 3. Tunggu cooldown Action LoadShop (cooldown 3 detik AQW)
                int waitCount = 0;
                while (!World.IsActionAvailable(LockActions.LoadShop) && waitCount < 30)
                {
                    await Task.Delay(100);
                    waitCount++;
                }

                // 4. Buka shop via Flash engine
                Shop.ResetShopInfo();
                Shop.Load(shop.Id);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Failed to load shop: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnUp_Click(object sender, EventArgs e)
        {
            var selectedIndices = lstShops.SelectedIndices.Cast<int>().OrderBy(i => i).ToList();
            if (selectedIndices.Count == 0 || selectedIndices[0] == 0)
                return;

            foreach (int index in selectedIndices)
            {
                var item = pinnedShops[index];
                pinnedShops.RemoveAt(index);
                pinnedShops.Insert(index - 1, item);
            }

            UpdateList();
            foreach (int index in selectedIndices)
            {
                lstShops.SetSelected(index - 1, true);
            }
        }

        private void btnDown_Click(object sender, EventArgs e)
        {
            var selectedIndices = lstShops.SelectedIndices.Cast<int>().OrderByDescending(i => i).ToList();
            if (selectedIndices.Count == 0 || selectedIndices[0] == pinnedShops.Count - 1)
                return;

            foreach (int index in selectedIndices)
            {
                var item = pinnedShops[index];
                pinnedShops.RemoveAt(index);
                pinnedShops.Insert(index + 1, item);
            }

            UpdateList();
            foreach (int index in selectedIndices)
            {
                lstShops.SetSelected(index + 1, true);
            }
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            SavePinnedShops();
            MessageBox.Show("Pinned shops list saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}

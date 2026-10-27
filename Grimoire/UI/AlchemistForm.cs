using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Game;
using Grimoire.Networking;
using Grimoire.Tools;

namespace Grimoire.UI
{
    public partial class AlchemistForm : DarkForm
    {
        public static AlchemistForm Instance { get; } = new AlchemistForm();

        private const string SearchPlaceholder = "Search...";
        private CancellationTokenSource _cts;
        private bool _isBrewing = false;

        private AlchemistForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private void AlchemistForm_Load(object sender, EventArgs e)
        {
            ApplyBoxDefaultDarkTheme();
            InitRecipeList();
        }

        private void AlchemistForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                StopBrewing();
                e.Cancel = true;
                Hide();
            }
        }

        private void pnlMaterials_Paint(object sender, PaintEventArgs e)
        {
            ControlPaint.DrawBorder(e.Graphics, pnlMaterials.ClientRectangle,
                Color.FromArgb(66, 66, 76), ButtonBorderStyle.Solid);
        }

        private void ApplyBoxDefaultDarkTheme()
        {
            pnlMaterials.BackColor = Color.FromArgb(30, 30, 36);
            lblBoxHeader.ForeColor = Color.White;
            lblCatalystTitle.ForeColor = Color.White;
            lblReagent1Title.ForeColor = Color.White;
            lblReagent2Title.ForeColor = Color.White;
            lblMaxBrews.ForeColor = Color.White;

            btnRefresh.BackColor = Color.FromArgb(46, 46, 56);
            btnRefresh.ForeColor = Color.White;
        }

        private void InitRecipeList(string filter = "")
        {
            try
            {
                cmbPotions.BeginUpdate();
                cmbPotions.Items.Clear();

                var list = AlchemistData.Recipes;
                if (!string.IsNullOrWhiteSpace(filter) && filter != SearchPlaceholder)
                {
                    list = list.Where(r => r.PotionName.IndexOf(filter, StringComparison.OrdinalIgnoreCase) >= 0).ToList();
                }

                foreach (var recipe in list)
                {
                    cmbPotions.Items.Add(recipe);
                }

                if (cmbPotions.Items.Count > 0)
                {
                    cmbPotions.SelectedIndex = 0;
                }
                else
                {
                    ClearMaterialStatus();
                }
            }
            finally
            {
                cmbPotions.EndUpdate();
            }

            UpdateMaterialStatus();
        }

        private void txtSearch_Enter(object sender, EventArgs e)
        {
            if (txtSearch.Text == SearchPlaceholder)
            {
                txtSearch.Text = "";
                txtSearch.ForeColor = Color.White;
            }
        }

        private void txtSearch_Leave(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtSearch.Text))
            {
                txtSearch.Text = SearchPlaceholder;
                txtSearch.ForeColor = Color.FromArgb(140, 140, 140);
            }
        }

        private void txtSearch_TextChanged(object sender, EventArgs e)
        {
            string query = txtSearch.Text;
            if (query == SearchPlaceholder) query = "";
            InitRecipeList(query.Trim());
        }

        private void cmbPotions_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateMaterialStatus();
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            Player.Inventory?.InvalidateCache();
            UpdateMaterialStatus();
        }

        private void ClearMaterialStatus()
        {
            ApplyBoxDefaultDarkTheme();

            lblCatalystTitle.Text = "Dragon Runestone [7132]:";
            lblCatalystStatus.Text = "-";
            lblCatalystStatus.ForeColor = Color.FromArgb(160, 160, 160);

            lblReagent1Title.Text = "Reagent 1:";
            lblReagent1Status.Text = "-";
            lblReagent1Status.ForeColor = Color.FromArgb(160, 160, 160);

            lblReagent2Title.Text = "Reagent 2:";
            lblReagent2Status.Text = "-";
            lblReagent2Status.ForeColor = Color.FromArgb(160, 160, 160);

            lblMaxBrews.Text = "Current bag capacity: 0x Brew";
            lblMaxBrews.ForeColor = Color.White;
        }

        private void UpdateMaterialStatus()
        {
            ApplyBoxDefaultDarkTheme();

            var recipe = cmbPotions.SelectedItem as AlchemyRecipe;
            if (recipe == null)
            {
                ClearMaterialStatus();
                return;
            }

            if (!Player.IsLoggedIn)
            {
                lblCatalystTitle.Text = "Dragon Runestone [7132]:";
                lblCatalystStatus.Text = "Not Logged In";
                lblCatalystStatus.ForeColor = Color.FromArgb(230, 90, 90);

                lblReagent1Title.Text = $"{recipe.Reagent1} [{recipe.Reagent1Id}]:";
                lblReagent1Status.Text = "Not Logged In";
                lblReagent1Status.ForeColor = Color.FromArgb(230, 90, 90);

                if (recipe.HasReagent2)
                {
                    lblReagent2Title.Text = $"{recipe.Reagent2} [{recipe.Reagent2Id}]:";
                    lblReagent2Status.Text = "Not Logged In";
                    lblReagent2Status.ForeColor = Color.FromArgb(230, 90, 90);
                }
                else
                {
                    lblReagent2Title.Text = "Reagent 2: None";
                    lblReagent2Status.Text = "- [None]";
                    lblReagent2Status.ForeColor = Color.FromArgb(160, 160, 160);
                }

                lblMaxBrews.Text = "Please log in to the game first.";
                lblMaxBrews.ForeColor = Color.White;
                return;
            }

            // 1. Dragon Runestone (Catalyst)
            int runestoneQty = GetInventoryItemQty(AlchemistData.DragonRunestoneId, AlchemistData.DragonRunestoneName);
            lblCatalystTitle.Text = "Dragon Runestone [7132]:";
            if (runestoneQty > 0)
            {
                lblCatalystStatus.Text = $"{runestoneQty} [READY]";
                lblCatalystStatus.ForeColor = Color.FromArgb(100, 220, 100);
            }
            else
            {
                lblCatalystStatus.Text = "0 [MISSING]";
                lblCatalystStatus.ForeColor = Color.FromArgb(230, 90, 90);
            }

            // 2. Reagent 1
            int.TryParse(recipe.Reagent1Id, out int r1Id);
            int r1Qty = GetInventoryItemQty(r1Id, recipe.Reagent1);
            lblReagent1Title.Text = $"{recipe.Reagent1} [{recipe.Reagent1Id}]:";
            if (r1Qty > 0)
            {
                lblReagent1Status.Text = $"{r1Qty} [READY]";
                lblReagent1Status.ForeColor = Color.FromArgb(100, 220, 100);
            }
            else
            {
                lblReagent1Status.Text = $"{r1Qty} [MISSING]";
                lblReagent1Status.ForeColor = Color.FromArgb(230, 90, 90);
            }

            // 3. Reagent 2
            int r2Qty = int.MaxValue;
            if (recipe.HasReagent2)
            {
                int.TryParse(recipe.Reagent2Id, out int r2Id);
                r2Qty = GetInventoryItemQty(r2Id, recipe.Reagent2);
                lblReagent2Title.Text = $"{recipe.Reagent2} [{recipe.Reagent2Id}]:";
                if (r2Qty > 0)
                {
                    lblReagent2Status.Text = $"{r2Qty} [READY]";
                    lblReagent2Status.ForeColor = Color.FromArgb(100, 220, 100);
                }
                else
                {
                    lblReagent2Status.Text = $"{r2Qty} [MISSING]";
                    lblReagent2Status.ForeColor = Color.FromArgb(230, 90, 90);
                }
            }
            else
            {
                lblReagent2Title.Text = "Reagent 2: None";
                lblReagent2Status.Text = "- [None]";
                lblReagent2Status.ForeColor = Color.FromArgb(160, 160, 160);
            }

            // Capacity calculation
            int maxPossible = Math.Min(runestoneQty, Math.Min(r1Qty, recipe.HasReagent2 ? r2Qty : r1Qty));
            lblMaxBrews.Text = $"Current bag capacity: {maxPossible}x Brew";
            lblMaxBrews.ForeColor = Color.White;
        }

        private int GetInventoryItemQty(int itemId, string itemName)
        {
            try
            {
                var items = Player.Inventory?.Items;
                if (items == null || items.Count == 0) return 0;

                if (itemId > 0)
                {
                    var byId = items.FirstOrDefault(i => i.Id == itemId);
                    if (byId != null) return byId.Quantity;
                }

                if (!string.IsNullOrEmpty(itemName))
                {
                    var byName = items.FirstOrDefault(i => i.Name.Equals(itemName, StringComparison.OrdinalIgnoreCase));
                    if (byName != null) return byName.Quantity;
                }
            }
            catch { }
            return 0;
        }

        private void btnStartStop_Click(object sender, EventArgs e)
        {
            if (_isBrewing)
            {
                StopBrewing();
                return;
            }

            StartBrewing();
        }

        private void StartBrewing()
        {
            if (!Player.IsLoggedIn)
            {
                MessageBox.Show("Please log in to the game first!", "CODEX Alchemist", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            var recipe = cmbPotions.SelectedItem as AlchemyRecipe;
            if (recipe == null)
            {
                MessageBox.Show("Please select a potion first!", "CODEX Alchemist", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            Player.Inventory?.InvalidateCache();
            int.TryParse(recipe.Reagent1Id, out int r1Id);
            int.TryParse(recipe.Reagent2Id, out int r2Id);

            int runestones = GetInventoryItemQty(AlchemistData.DragonRunestoneId, AlchemistData.DragonRunestoneName);
            int r1 = GetInventoryItemQty(r1Id, recipe.Reagent1);
            int r2 = recipe.HasReagent2 ? GetInventoryItemQty(r2Id, recipe.Reagent2) : 999;

            if (chkStopIfOut.Checked && (runestones < 1 || r1 < 1 || r2 < 1))
            {
                MessageBox.Show("Insufficient materials in inventory to start brewing!", "CODEX Alchemist", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            int targetCount = (int)numTarget.Value;
            if (targetCount <= 0) targetCount = 1;

            _isBrewing = true;
            btnStartStop.Text = "STOP BREWING";
            btnStartStop.ForeColor = Color.FromArgb(255, 120, 120);
            txtSearch.Enabled = false;
            cmbPotions.Enabled = false;
            numTarget.Enabled = false;
            chkStopIfOut.Enabled = false;
            btnRefresh.Enabled = false;

            progressBar.Minimum = 0;
            progressBar.Maximum = targetCount;
            progressBar.Value = 0;
            lblStatus.Text = $"Status: Starting brewing (Target: {targetCount})...";

            _cts = new CancellationTokenSource();
            CancellationToken token = _cts.Token;

            Task.Run(() => RunBrewLoop(recipe, targetCount, token));
        }

        private void StopBrewing()
        {
            if (_isBrewing)
            {
                _cts?.Cancel();
                lblStatus.Text = "Status: Stopping brewing...";
            }
        }

        private async Task RunBrewLoop(AlchemyRecipe recipe, int targetCount, CancellationToken token)
        {
            int current = 0;
            string stopReason = "";

            try
            {
                int.TryParse(recipe.Reagent1Id, out int r1Id);
                int.TryParse(recipe.Reagent2Id, out int r2Id);

                while (current < targetCount)
                {
                    if (token.IsCancellationRequested || !Player.IsLoggedIn)
                        break;

                    if (chkStopIfOut.Checked)
                    {
                        Player.Inventory?.InvalidateCache();
                        int runestones = GetInventoryItemQty(AlchemistData.DragonRunestoneId, AlchemistData.DragonRunestoneName);
                        int r1 = GetInventoryItemQty(r1Id, recipe.Reagent1);
                        int r2 = recipe.HasReagent2 ? GetInventoryItemQty(r2Id, recipe.Reagent2) : 999;

                        if (runestones < 1 || r1 < 1 || r2 < 1)
                        {
                            stopReason = "Out of materials in inventory";
                            break;
                        }
                    }

                    int brewStep = current + 1;

                    // 1. Packet START
                    SafeInvoke(() =>
                    {
                        lblStatus.Text = $"[{brewStep}/{targetCount}] Sending START packet...";
                    });

                    await Proxy.Instance.SendToServer(recipe.GetPacketStart());

                    // Delay 1200 ms
                    await Task.Delay(1200, token);
                    if (token.IsCancellationRequested) break;

                    // 2. Packet COMPLETE
                    SafeInvoke(() =>
                    {
                        lblStatus.Text = $"[{brewStep}/{targetCount}] Sending COMPLETE packet...";
                    });

                    await Proxy.Instance.SendToServer(recipe.GetPacketComplete());

                    // Delay 1200 ms
                    await Task.Delay(1200, token);

                    current++;

                    SafeInvoke(() =>
                    {
                        progressBar.Value = Math.Min(current, targetCount);
                        lblStatus.Text = $"Status: {current}/{targetCount} brewed.";
                        Player.Inventory?.InvalidateCache();
                        UpdateMaterialStatus();
                    });
                }
            }
            catch (TaskCanceledException)
            {
                stopReason = "Stopped by player";
            }
            catch (Exception ex)
            {
                stopReason = $"Error: {ex.Message}";
            }
            finally
            {
                SafeInvoke(() =>
                {
                    _isBrewing = false;
                    btnStartStop.Text = "START BREWING";
                    btnStartStop.ForeColor = Color.FromArgb(220, 220, 220);
                    txtSearch.Enabled = true;
                    cmbPotions.Enabled = true;
                    numTarget.Enabled = true;
                    chkStopIfOut.Enabled = true;
                    btnRefresh.Enabled = true;

                    Player.Inventory?.InvalidateCache();
                    UpdateMaterialStatus();

                    if (!string.IsNullOrEmpty(stopReason))
                    {
                        lblStatus.Text = $"Status: {stopReason} ({current}/{targetCount} completed).";
                    }
                    else if (current >= targetCount)
                    {
                        lblStatus.Text = $"Status: Finished! Successfully brewed {current} potions.";
                    }
                    else
                    {
                        lblStatus.Text = $"Status: Finished ({current}/{targetCount}).";
                    }
                });
            }
        }

        private void SafeInvoke(Action action)
        {
            if (IsDisposed || !IsHandleCreated) return;
            try
            {
                if (InvokeRequired)
                    Invoke(action);
                else
                    action();
            }
            catch { }
        }
    }
}

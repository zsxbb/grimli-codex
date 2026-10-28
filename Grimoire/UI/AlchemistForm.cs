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

        private readonly object _dropLock = new object();
        private readonly List<Game.Data.InventoryItem> _droppedItemsThisBrew = new List<Game.Data.InventoryItem>();
        private string _targetPotionName = "";

        private void OnAlchemyDropReceived(Game.Data.InventoryItem drop)
        {
            if (drop == null || string.IsNullOrEmpty(drop.Name)) return;

            // Ignore catalyst if returned/dropped
            if (drop.Name.Equals(AlchemistData.DragonRunestoneName, StringComparison.OrdinalIgnoreCase))
                return;

            // Auto-pickup drop ONLY if it matches the target potion
            if (!string.IsNullOrEmpty(_targetPotionName) &&
                drop.Name.Equals(_targetPotionName, StringComparison.OrdinalIgnoreCase))
            {
                Task.Run(async () =>
                {
                    try
                    {
                        await World.DropStack.GetDrop(drop.Id);
                    }
                    catch { }
                });
            }

            // Always track in _droppedItemsThisBrew so it gets recorded in Done Total
            lock (_dropLock)
            {
                _droppedItemsThisBrew.Add(new Game.Data.InventoryItem
                {
                    Id = drop.Id,
                    Name = drop.Name,
                    Quantity = drop.Quantity > 0 ? drop.Quantity : 1
                });
            }
        }

        private void ApplyBoxDefaultDarkTheme()
        {
            pnlMaterials.BackColor = Color.FromArgb(30, 30, 36);
            lblBoxHeader.ForeColor = Color.White;
            lblCatalystTitle.ForeColor = Color.White;
            lblReagent1Title.ForeColor = Color.White;
            lblReagent2Title.ForeColor = Color.White;
            lblPotionTitle.ForeColor = Color.FromArgb(220, 220, 220);

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

        private void rbTarget_CheckedChanged(object sender, EventArgs e)
        {
            var recipe = cmbPotions.SelectedItem as AlchemyRecipe;
            if (recipe == null) return;

            if (rbTargetPotion.Checked)
            {
                int curQty = GetInventoryItemQty(0, recipe.PotionName);
                if (curQty > 0 && numTarget.Value <= curQty)
                {
                    numTarget.Value = Math.Min(numTarget.Maximum, curQty + 10);
                }
            }
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
            lblCatalystStatus.ForeColor = UISkinManager.SecondaryTextColor;

            lblReagent1Title.Text = "Reagent 1:";
            lblReagent1Status.Text = "-";
            lblReagent1Status.ForeColor = UISkinManager.SecondaryTextColor;

            lblReagent2Title.Text = "Reagent 2:";
            lblReagent2Status.Text = "-";
            lblReagent2Status.ForeColor = UISkinManager.SecondaryTextColor;

            lblPotionTitle.Text = "Potion in Bag:";
            lblPotionStatus.Text = "-";
            lblPotionStatus.ForeColor = UISkinManager.SecondaryTextColor;
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
                    lblReagent2Status.ForeColor = UISkinManager.SecondaryTextColor;
                }

                lblPotionTitle.Text = "Potion in Bag:";
                lblPotionStatus.Text = "-";
                lblPotionStatus.ForeColor = UISkinManager.SecondaryTextColor;
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
                lblReagent2Status.ForeColor = UISkinManager.SecondaryTextColor;
            }

            // 4. Target Potion in Bag (Detect ID & Quantity)
            var invItems = Player.Inventory?.Items;
            var potItem = invItems?.FirstOrDefault(i => i.Name.Equals(recipe.PotionName, StringComparison.OrdinalIgnoreCase));
            int potQty = potItem?.Quantity ?? 0;
            int potId = potItem?.Id ?? 0;

            if (potItem != null && potQty > 0)
            {
                lblPotionTitle.Text = $"Potion in Bag [{potId}]:";
                lblPotionStatus.Text = $"{potQty}";
                lblPotionStatus.ForeColor = Color.FromArgb(100, 220, 100);
            }
            else
            {
                lblPotionTitle.Text = "Potion in Bag:";
                lblPotionStatus.Text = "0";
                lblPotionStatus.ForeColor = UISkinManager.SecondaryTextColor;
            }
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

            bool isTargetPotion = rbTargetPotion.Checked;
            int targetCount = (int)numTarget.Value;
            if (targetCount <= 0) targetCount = 1;

            int currentInBag = GetInventoryItemQty(0, recipe.PotionName);
            if (isTargetPotion && currentInBag >= targetCount)
            {
                MessageBox.Show(
                    $"Potion in bag ({currentInBag}) already meets or exceeds target ({targetCount})!",
                    "CODEX Alchemist",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
                return;
            }

            _isBrewing = true;
            btnStartStop.Text = "STOP BREWING";
            btnStartStop.ForeColor = Color.FromArgb(255, 120, 120);
            txtSearch.Enabled = false;
            cmbPotions.Enabled = false;
            rbTargetBrew.Enabled = false;
            rbTargetPotion.Enabled = false;
            numTarget.Enabled = false;
            chkStopIfOut.Enabled = false;
            btnRefresh.Enabled = false;

            if (isTargetPotion)
            {
                progressBar.Minimum = Math.Min(currentInBag, targetCount);
                progressBar.Maximum = targetCount;
                progressBar.Value = Math.Min(currentInBag, targetCount);
                lblStatus.Text = $"Status: Starting brewing (Target: {targetCount} in bag)...";
            }
            else
            {
                progressBar.Minimum = 0;
                progressBar.Maximum = targetCount;
                progressBar.Value = 0;
                lblStatus.Text = $"Status: Starting brewing (Target: {targetCount} brews)...";
            }

            _cts = new CancellationTokenSource();
            CancellationToken token = _cts.Token;

            Task.Run(() => RunBrewLoop(recipe, targetCount, isTargetPotion, token));
        }

        private void StopBrewing()
        {
            if (_isBrewing)
            {
                _cts?.Cancel();
                lblStatus.Text = "Status: Stopping brewing...";
            }
        }

        private async Task RunBrewLoop(AlchemyRecipe recipe, int targetVal, bool isTargetPotion, CancellationToken token)
        {
            int totalBrews = 0;
            string stopReason = "";
            var sessionGained = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

            try
            {
                _targetPotionName = recipe.PotionName;
                // Hook drop listener to detect drops and auto-pickup target potion
                World.ItemDropped += OnAlchemyDropReceived;

                int.TryParse(recipe.Reagent1Id, out int r1Id);
                int.TryParse(recipe.Reagent2Id, out int r2Id);

                while (true)
                {
                    if (token.IsCancellationRequested || !Player.IsLoggedIn)
                        break;

                    Player.Inventory?.InvalidateCache();
                    int currentInBag = GetInventoryItemQty(0, recipe.PotionName);

                    if (isTargetPotion && currentInBag >= targetVal)
                        break;

                    if (!isTargetPotion && totalBrews >= targetVal)
                        break;

                    if (chkStopIfOut.Checked)
                    {
                        int runestones = GetInventoryItemQty(AlchemistData.DragonRunestoneId, AlchemistData.DragonRunestoneName);
                        int r1 = GetInventoryItemQty(r1Id, recipe.Reagent1);
                        int r2 = recipe.HasReagent2 ? GetInventoryItemQty(r2Id, recipe.Reagent2) : 999;

                        if (runestones < 1 || r1 < 1 || r2 < 1)
                        {
                            stopReason = "Out of materials";
                            break;
                        }
                    }

                    int brewStep = totalBrews + 1;

                    // Clear drop tracker for this brew iteration
                    lock (_dropLock)
                    {
                        _droppedItemsThisBrew.Clear();
                    }

                    // Take snapshot of inventory before mix
                    var itemsBefore = Player.Inventory?.Items?.ToList() ?? new List<Game.Data.InventoryItem>();
                    var qtyBeforeById = new Dictionary<int, int>();
                    var qtyBeforeByName = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
                    foreach (var it in itemsBefore)
                    {
                        if (it == null) continue;
                        qtyBeforeById[it.Id] = it.Quantity;
                        if (!string.IsNullOrEmpty(it.Name))
                            qtyBeforeByName[it.Name] = it.Quantity;
                    }

                    // 1. Packet START
                    SafeInvoke(() =>
                    {
                        if (isTargetPotion)
                            lblStatus.Text = $"[Brew #{brewStep}] Starting mix: {recipe.PotionName}...\r\nBag: {currentInBag}/{targetVal}";
                        else
                            lblStatus.Text = $"[{brewStep}/{targetVal}] Starting mix: {recipe.PotionName}...\r\nBag: {currentInBag}";
                    });

                    await Proxy.Instance.SendToServer(recipe.GetPacketStart());

                    // Wait 18 seconds with live countdown
                    for (int sec = 18; sec > 0; sec--)
                    {
                        if (token.IsCancellationRequested) break;
                        int remainingSec = sec;
                        SafeInvoke(() =>
                        {
                            if (isTargetPotion)
                                lblStatus.Text = $"[Brew #{brewStep}] Mixing in progress... {remainingSec}s remaining\r\nBag: {currentInBag}/{targetVal}";
                            else
                                lblStatus.Text = $"[{brewStep}/{targetVal}] Mixing in progress... {remainingSec}s remaining\r\nBag: {currentInBag}";
                        });
                        await Task.Delay(1000, token);
                    }
                    if (token.IsCancellationRequested) break;

                    // 2. Packet COMPLETE (alchDone)
                    SafeInvoke(() =>
                    {
                        lblStatus.Text = "Completing mix (alchDone)...\r\nWaiting for server drops...";
                    });

                    await Proxy.Instance.SendToServer(recipe.GetPacketComplete());

                    // Allow time for server to respond with drop packets
                    await Task.Delay(1200, token);

                    // Ensure targeted potion in World.DropStack is picked up
                    try
                    {
                        var remainingDrops = World.DropStack?.ToList();
                        if (remainingDrops != null && remainingDrops.Count > 0)
                        {
                            foreach (var d in remainingDrops)
                            {
                                if (d == null) continue;
                                if (d.Name.Equals(recipe.PotionName, StringComparison.OrdinalIgnoreCase))
                                {
                                    await World.DropStack.GetDrop(d.Id);
                                }
                            }
                        }
                    }
                    catch { }

                    // Brief pause for pickups to finalize in inventory
                    await Task.Delay(600, token);

                    Player.Inventory?.InvalidateCache();
                    var itemsAfter = Player.Inventory?.Items?.ToList() ?? new List<Game.Data.InventoryItem>();

                    // Tally all gains from this brew
                    var stepTally = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

                    // 1. Check inventory diff
                    foreach (var item in itemsAfter)
                    {
                        if (item == null || string.IsNullOrEmpty(item.Name)) continue;
                        int prevQty = 0;
                        if (qtyBeforeById.TryGetValue(item.Id, out int q))
                            prevQty = q;
                        else if (qtyBeforeByName.TryGetValue(item.Name, out int qn))
                            prevQty = qn;

                        int gained = item.Quantity - prevQty;
                        if (gained > 0 &&
                            !item.Name.Equals(AlchemistData.DragonRunestoneName, StringComparison.OrdinalIgnoreCase) &&
                            !item.Name.Equals(recipe.Reagent1, StringComparison.OrdinalIgnoreCase) &&
                            (!recipe.HasReagent2 || !item.Name.Equals(recipe.Reagent2, StringComparison.OrdinalIgnoreCase)))
                        {
                            stepTally[item.Name] = gained;
                        }
                    }

                    // 2. Also incorporate any dropped items captured by World.ItemDropped
                    lock (_dropLock)
                    {
                        foreach (var drop in _droppedItemsThisBrew)
                        {
                            if (drop == null || string.IsNullOrEmpty(drop.Name)) continue;
                            if (!stepTally.ContainsKey(drop.Name))
                            {
                                stepTally[drop.Name] = drop.Quantity > 0 ? drop.Quantity : 1;
                            }
                        }
                    }

                    // Accumulate into overall session tracker
                    List<string> stepGains = new List<string>();
                    foreach (var kvp in stepTally)
                    {
                        if (!sessionGained.ContainsKey(kvp.Key))
                            sessionGained[kvp.Key] = 0;
                        sessionGained[kvp.Key] += kvp.Value;
                        stepGains.Add($"{kvp.Key}: +{kvp.Value}");
                    }

                    totalBrews++;
                    currentInBag = GetInventoryItemQty(0, recipe.PotionName);

                    SafeInvoke(() =>
                    {
                        if (isTargetPotion)
                        {
                            progressBar.Value = Math.Min(Math.Max(currentInBag, progressBar.Minimum), progressBar.Maximum);
                        }
                        else
                        {
                            progressBar.Value = Math.Min(totalBrews, progressBar.Maximum);
                        }

                        string stepGainText = stepGains.Count > 0 ? string.Join(", ", stepGains) : "+0 pot";
                        if (isTargetPotion)
                            lblStatus.Text = $"[Brew #{totalBrews}] {stepGainText}\r\nBag: {currentInBag}/{targetVal}";
                        else
                            lblStatus.Text = $"[{totalBrews}/{targetVal}] {stepGainText}\r\nBag: {currentInBag}";

                        UpdateMaterialStatus();
                    });

                    // Check if target condition reached
                    if (isTargetPotion && currentInBag >= targetVal)
                        break;
                    if (!isTargetPotion && totalBrews >= targetVal)
                        break;

                    // Cooldown 2 seconds before next mix if more remain
                    for (int cd = 2; cd > 0; cd--)
                    {
                        if (token.IsCancellationRequested) break;
                        int remainingCd = cd;
                        SafeInvoke(() =>
                        {
                            lblStatus.Text = $"Cooldown before next mix: {remainingCd}s...\r\nBag: {currentInBag}";
                        });
                        await Task.Delay(1000, token);
                    }
                    if (token.IsCancellationRequested) break;
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
                World.ItemDropped -= OnAlchemyDropReceived;
                _targetPotionName = "";

                SafeInvoke(() =>
                {
                    _isBrewing = false;
                    btnStartStop.Text = "START BREWING";
                    btnStartStop.ForeColor = Color.FromArgb(220, 220, 220);
                    txtSearch.Enabled = true;
                    cmbPotions.Enabled = true;
                    rbTargetBrew.Enabled = true;
                    rbTargetPotion.Enabled = true;
                    numTarget.Enabled = true;
                    chkStopIfOut.Enabled = true;
                    btnRefresh.Enabled = true;

                    Player.Inventory?.InvalidateCache();
                    UpdateMaterialStatus();

                    lblStatus.Text = BuildDoneSummary(stopReason, sessionGained, totalBrews);
                });
            }
        }

        private string BuildDoneSummary(string stopReason, Dictionary<string, int> sessionGained, int totalBrews)
        {
            var sb = new System.Text.StringBuilder();
            if (!string.IsNullOrEmpty(stopReason))
            {
                sb.AppendLine(stopReason);
            }

            sb.AppendLine("Done Total:");
            if (sessionGained.Count > 0)
            {
                foreach (var kvp in sessionGained)
                {
                    sb.AppendLine($"{kvp.Key}: +{kvp.Value}");
                }
            }
            else
            {
                sb.AppendLine("No potions gained");
            }
            sb.Append($"{totalBrews} brew{(totalBrews == 1 ? "" : "s")}");
            return sb.ToString();
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

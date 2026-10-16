using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Game;
using Grimoire.Networking;
using Grimoire.Tools;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Grimoire.UI
{
    public partial class CodexSkillForm : DarkForm
    {
        public static CodexSkillForm Instance { get; } = new CodexSkillForm();

        private List<SkillMomentRule> _rules = new List<SkillMomentRule>();

        private CodexSkillForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private void CodexSkillForm_Load(object sender, EventArgs e)
        {
            // Initialize Skill Moment defaults
            cmbTriggerType.SelectedIndex = 0;
            cmbSkill1.SelectedIndex = 4;
            cmbOccurrence.SelectedIndex = 0;
            cmbHpType.SelectedIndex = 0;
            txtHpValue.Text = "70, 50, 30";
            txtDelay.Text = "0";
        }

        private void chkEnableSkillMoment_CheckedChanged(object sender, EventArgs e)
        {
            Flash.FlashCall2 -= SkillMomentAnimsHandler;
            if (chkEnableSkillMoment.Checked)
            {
                foreach (var rule in _rules)
                {
                    rule.MatchCount = 0;
                }
                Flash.FlashCall2 += SkillMomentAnimsHandler;
            }
        }

        private void cmbTriggerType_SelectedIndexChanged(object sender, EventArgs e)
        {
            bool isMsg = cmbTriggerType.SelectedIndex == 0;

            lblKeyword.Visible = isMsg;
            txtKeyword.Visible = isMsg;
            lblOccurrence.Visible = isMsg;
            cmbOccurrence.Visible = isMsg;

            lblHpType.Visible = !isMsg;
            cmbHpType.Visible = !isMsg;
            lblHpValue.Visible = !isMsg;
            txtHpValue.Visible = !isMsg;
        }

        private void btnAddRule_Click(object sender, EventArgs e)
        {
            if (cmbTriggerType.SelectedIndex < 0)
            {
                MessageBox.Show("Please select a trigger type!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if (cmbSkill1.SelectedIndex < 0)
            {
                MessageBox.Show("Please select a skill action!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            string triggerType = cmbTriggerType.SelectedItem.ToString();
            string skill1 = cmbSkill1.SelectedItem.ToString();

            string keyword = "";
            string occurrence = "";
            string hpType = "";
            string hpValueStr = "";

            if (triggerType == "By Message")
            {
                keyword = txtKeyword.Text.Trim();
                if (string.IsNullOrEmpty(keyword))
                {
                    MessageBox.Show("Keyword cannot be empty for By Message trigger!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                occurrence = cmbOccurrence.SelectedIndex >= 0 ? cmbOccurrence.SelectedItem.ToString() : "All Matches";
            }
            else // By HP Monster
            {
                hpType = cmbHpType.SelectedIndex >= 0 ? cmbHpType.SelectedItem.ToString() : "Percentage (%)";
                hpValueStr = txtHpValue.Text.Trim();
                if (string.IsNullOrEmpty(hpValueStr))
                {
                    MessageBox.Show("Thresholds cannot be empty for By HP Monster trigger!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
            }

            int delaySeconds = 0;
            if (!int.TryParse(txtDelay.Text.Trim(), out delaySeconds))
            {
                delaySeconds = 0;
            }

            var rule = new SkillMomentRule
            {
                TriggerType = triggerType,
                Keyword = keyword,
                Skill1 = skill1,
                Occurrence = occurrence,
                HpType = hpType,
                HpValueString = hpValueStr,
                DelaySeconds = delaySeconds
            };

            _rules.Add(rule);
            lstRules.Items.Add(rule);

            // Reset inputs
            txtKeyword.Clear();
            txtDelay.Text = "0";
        }

        private void btnRemoveRule_Click(object sender, EventArgs e)
        {
            if (lstRules.SelectedIndex >= 0)
            {
                int idx = lstRules.SelectedIndex;
                _rules.RemoveAt(idx);
                lstRules.Items.RemoveAt(idx);
            }
            else
            {
                MessageBox.Show("Please select a rule to remove!", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void btnSaveRules_Click(object sender, EventArgs e)
        {
            string configFolder = Path.Combine(Application.StartupPath, "Config");
            if (!Directory.Exists(configFolder))
                Directory.CreateDirectory(configFolder);

            using (SaveFileDialog saveFileDialog = new SaveFileDialog())
            {
                saveFileDialog.Title = "Save Skill Moment Rules";
                saveFileDialog.InitialDirectory = configFolder;
                saveFileDialog.Filter = "Skill Moment Config|*.json";
                saveFileDialog.DefaultExt = ".json";
                if (saveFileDialog.ShowDialog() == DialogResult.OK)
                {
                    try
                    {
                        File.WriteAllText(saveFileDialog.FileName, JsonConvert.SerializeObject(_rules, Formatting.Indented));
                        MessageBox.Show("Rules saved successfully!", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Unable to save rules: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void btnLoadRules_Click(object sender, EventArgs e)
        {
            string configFolder = Path.Combine(Application.StartupPath, "Config");
            if (!Directory.Exists(configFolder))
                Directory.CreateDirectory(configFolder);

            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.Title = "Load Skill Moment Rules";
                openFileDialog.InitialDirectory = configFolder;
                openFileDialog.Filter = "Skill Moment Config|*.json";
                openFileDialog.DefaultExt = ".json";
                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    try
                    {
                        string json = File.ReadAllText(openFileDialog.FileName);
                        var loadedRules = JsonConvert.DeserializeObject<List<SkillMomentRule>>(json);
                        if (loadedRules != null)
                        {
                            _rules = loadedRules;
                            lstRules.Items.Clear();
                            foreach (var rule in _rules)
                            {
                                lstRules.Items.Add(rule);
                            }
                            MessageBox.Show("Rules loaded successfully!", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Unable to load rules: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void timerUpdate_Tick(object sender, EventArgs e)
        {
            if (!Player.IsAlive)
            {
                lblCurrentTarget.Text = "Target: None";
                foreach (var rule in _rules)
                {
                    rule.MatchCount = 0;
                    if (rule.TriggeredThresholds != null)
                        rule.TriggeredThresholds.Clear();
                    rule.LastTargetName = null;
                }
                return;
            }

            string rawTargetName = Player.GetTargetName;
            if (string.IsNullOrEmpty(rawTargetName) || rawTargetName == "null")
            {
                lblCurrentTarget.Text = "Target: None";
            }
            else
            {
                lblCurrentTarget.Text = "Target: " + rawTargetName.Replace("\"", "");
            }

            if (chkEnableSkillMoment.Checked)
            {
                try
                {
                    string currentTargetName = Player.GetTargetName;
                    if (string.IsNullOrEmpty(currentTargetName) || currentTargetName == "null")
                        return;

                    currentTargetName = currentTargetName.Replace("\"", "");

                    int currentMaxHp = 0;
                    try
                    {
                        string maxHpStr = Flash.GetGameObject("world.myAvatar.target.objData.intHPMax");
                        if (!string.IsNullOrEmpty(maxHpStr) && maxHpStr != "null")
                            currentMaxHp = int.Parse(maxHpStr.Replace("\"", ""));
                    }
                    catch { }

                    string currentTargetKey = $"{currentTargetName}_{currentMaxHp}";

                    foreach (var rule in _rules)
                    {
                        if (rule.TriggerType == "By HP Monster")
                        {
                            if (rule.LastTargetName != currentTargetKey)
                            {
                                rule.LastTargetName = currentTargetKey;
                                if (rule.TriggeredThresholds == null)
                                    rule.TriggeredThresholds = new HashSet<int>();
                                else
                                    rule.TriggeredThresholds.Clear();
                            }

                            int currentHpVal = (rule.HpType == "Percentage (%)") ? GetTargetHealthPercent() : GetTargetHealthActual();
                            if (currentHpVal < 0) continue;

                            // Remove any triggered thresholds that the monster's HP has now exceeded (e.g., due to reset or heal)
                            if (rule.TriggeredThresholds != null)
                            {
                                rule.TriggeredThresholds.RemoveWhere(th => currentHpVal > th);
                            }

                            var thresholds = rule.ParseThresholds();
                            bool thresholdMatched = false;
                            int matchedThreshold = -1;
                            foreach (int th in thresholds)
                            {
                                if (currentHpVal <= th)
                                {
                                    if (rule.TriggeredThresholds == null)
                                        rule.TriggeredThresholds = new HashSet<int>();

                                    if (!rule.TriggeredThresholds.Contains(th))
                                    {
                                        rule.TriggeredThresholds.Add(th);
                                        thresholdMatched = true;
                                        matchedThreshold = th;
                                        break;
                                    }
                                }
                            }

                            if (thresholdMatched)
                            {
                                string skillToUse = rule.Skill1;
                                int delaySec = rule.DelaySeconds;
                                TriggerSkillMoment(rule, matchedThreshold, skillToUse, delaySec);
                            }
                        }
                    }
                }
                catch { }
            }
        }

        private async void TriggerSkillMoment(SkillMomentRule rule, int th, string skillToUse, int delaySec)
        {
            bool success = await ExecuteSkillWithWait(skillToUse, delaySec);
            if (!success && chkEnableSkillMoment.Checked && rule.TriggeredThresholds != null && Player.IsAlive)
            {
                rule.TriggeredThresholds.Remove(th);
            }
        }

        private int GetTargetHealthPercent()
        {
            try
            {
                string hpStr = Flash.GetGameObject("world.myAvatar.target.objData.intHP");
                string maxHpStr = Flash.GetGameObject("world.myAvatar.target.objData.intHPMax");
                if (!string.IsNullOrEmpty(hpStr) && !string.IsNullOrEmpty(maxHpStr) && hpStr != "null" && maxHpStr != "null")
                {
                    int hp = int.Parse(hpStr.Replace("\"", ""));
                    int maxHp = int.Parse(maxHpStr.Replace("\"", ""));
                    if (maxHp > 0)
                    {
                        return (int)(((double)hp / maxHp) * 100);
                    }
                }
            }
            catch { }
            return -1;
        }

        private int GetTargetHealthActual()
        {
            try
            {
                string hpStr = Flash.GetGameObject("world.myAvatar.target.objData.intHP");
                if (!string.IsNullOrEmpty(hpStr) && hpStr != "null")
                {
                    return int.Parse(hpStr.Replace("\"", ""));
                }
            }
            catch { }
            return -1;
        }

        private async Task<bool> ExecuteSkillWithWait(string index, int delaySeconds)
        {
            try
            {
                if (delaySeconds > 0)
                {
                    await Task.Delay(delaySeconds * 1000);
                }

                if (!Player.IsAlive) return false;
                int cd = Player.SkillAvailable(index);
                await Task.Delay(Math.Min(cd, 1500));
                if (!Player.IsAlive) return false;
                Player.ForceUseSkill(index);
                for (int i = 0; i < 10; i++)
                {
                    await Task.Delay(100);
                    if (!Player.IsAlive) return false;
                    if (Player.SkillAvailable(index) > 0)
                        return true;
                }
                Player.ForceUseSkill(index);
                await Task.Delay(100);
                if (Player.SkillAvailable(index) > 0)
                    return true;
            }
            catch { }
            return false;
        }

        private void SkillMomentAnimsHandler(string function, params object[] args)
        {
            if (function != "packetFromServer" || !chkEnableSkillMoment.Checked) return;
            try
            {
                string rawPacket = (string)args[0];
                if (string.IsNullOrEmpty(rawPacket)) return;

                if (rawPacket.StartsWith("{"))
                {
                    JObject json = JObject.Parse(rawPacket);
                    JObject bigObj = (JObject)json["b"]?["o"];
                    if (bigObj == null) return;

                    JArray anims = (JArray)bigObj["anims"];
                    if (anims != null)
                    {
                        foreach (JObject anim in anims)
                        {
                            string msg = anim?["msg"]?.ToString()?.ToLower();
                            if (string.IsNullOrEmpty(msg)) continue;

                            foreach (var rule in _rules)
                            {
                                string triggerType = rule.TriggerType ?? "By Message";
                                if (triggerType != "By Message") continue;

                                if (msg.Contains(rule.Keyword.ToLower()))
                                {
                                    rule.MatchCount++;

                                    if (rule.Occurrence == "Odd Matches (1, 3, 5...)")
                                    {
                                        if (rule.MatchCount % 2 == 0) continue;
                                    }
                                    else if (rule.Occurrence == "Even Matches (2, 4, 6...)")
                                    {
                                        if (rule.MatchCount % 2 != 0) continue;
                                    }

                                    string skillToUse = rule.Skill1;
                                    int delaySec = rule.DelaySeconds;
                                    _ = ExecuteSkillWithWait(skillToUse, delaySec);
                                }
                            }
                        }
                    }
                }
            }
            catch { }
        }

        private void CodexSkillForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }
    }

    public class SkillMomentRule
    {
        public string TriggerType { get; set; }
        public string Keyword { get; set; }
        public string Skill1 { get; set; }
        public string Occurrence { get; set; }
        public string HpType { get; set; }
        public string HpValueString { get; set; }
        public int DelaySeconds { get; set; } = 0;

        [JsonIgnore]
        public int MatchCount { get; set; }

        [JsonIgnore]
        public string LastTargetName { get; set; }

        [JsonIgnore]
        public HashSet<int> TriggeredThresholds { get; set; } = new HashSet<int>();

        public List<int> ParseThresholds()
        {
            var list = new List<int>();
            if (string.IsNullOrEmpty(HpValueString)) return list;
            try
            {
                var parts = HpValueString.Split(',');
                foreach (var part in parts)
                {
                    if (int.TryParse(part.Trim(), out int val))
                    {
                        list.Add(val);
                    }
                }
            }
            catch { }
            return list.OrderByDescending(x => x).ToList();
        }

        public override string ToString()
        {
            string triggerType = TriggerType ?? "By Message";
            string skillAction = $"Skill {Skill1}";
            string delayStr = DelaySeconds > 0 ? $" [{DelaySeconds}s]" : "";

            if (triggerType == "By Message")
            {
                string occStr = "";
                if (Occurrence == "Odd Matches (1, 3, 5...)") occStr = " (Odd)";
                else if (Occurrence == "Even Matches (2, 4, 6...)") occStr = " (Even)";

                return $"[Msg] \"{Keyword}\"{occStr}{delayStr} -> {skillAction}";
            }
            else // By HP Monster
            {
                string hpTypeSuffix = HpType == "Percentage (%)" ? "%" : "";
                return $"[HP] <= {HpValueString}{hpTypeSuffix}{delayStr} -> {skillAction}";
            }
        }
    }
}

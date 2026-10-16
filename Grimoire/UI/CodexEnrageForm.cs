using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Game;
using Grimoire.Networking;
using Grimoire.Tools;
using Newtonsoft.Json.Linq;

namespace Grimoire.UI
{
    public partial class CodexEnrageForm : DarkForm
    {
        public static CodexEnrageForm Instance { get; } = new CodexEnrageForm();

        private DateTime _focusAppliedTime = DateTime.MinValue;
        private bool _hasCastEnrage = false;

        private CodexEnrageForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private void CodexEnrageForm_Load(object sender, EventArgs e)
        {
            cmbSkill.SelectedIndex = 4; // Default to Skill 5
        }

        private void chkEnableLoopEnrage_CheckedChanged(object sender, EventArgs e)
        {
            Flash.FlashCall2 -= LoopEnragePacketHandler;
            if (chkEnableLoopEnrage.Checked)
            {
                _focusAppliedTime = DateTime.MinValue;
                _hasCastEnrage = false;
                Flash.FlashCall2 += LoopEnragePacketHandler;
            }
        }

        private void LoopEnragePacketHandler(string function, params object[] args)
        {
            if (function != "packetFromServer" || !chkEnableLoopEnrage.Checked) return;
            try
            {
                string rawPacket = (string)args[0];
                if (string.IsNullOrEmpty(rawPacket)) return;

                if (rawPacket.StartsWith("{"))
                {
                    JObject json = JObject.Parse(rawPacket);
                    JObject bigObj = (JObject)json["b"]?["o"];
                    if (bigObj == null) return;

                    JArray actions = (JArray)bigObj["a"];
                    if (actions != null)
                    {
                        foreach (JObject action in actions)
                        {
                            string cmd = action["cmd"]?.ToString();
                            if (cmd == "aura+")
                            {
                                JArray auras = (JArray)action["auras"];
                                if (auras != null)
                                {
                                    foreach (JObject aura in auras)
                                    {
                                        string name = aura["nam"]?.ToString();
                                        if (string.Equals(name, txtAuraName.Text.Trim(), StringComparison.OrdinalIgnoreCase))
                                        {
                                            _focusAppliedTime = DateTime.Now;
                                            _hasCastEnrage = false;
                                        }
                                    }
                                }
                            }
                            else if (cmd == "aura-")
                            {
                                JObject aura = (JObject)action["aura"];
                                if (aura != null)
                                {
                                    string name = aura["nam"]?.ToString();
                                    if (string.Equals(name, txtAuraName.Text.Trim(), StringComparison.OrdinalIgnoreCase))
                                    {
                                        _focusAppliedTime = DateTime.MinValue;
                                        _hasCastEnrage = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch { }
        }

        private void timerUpdate_Tick(object sender, EventArgs e)
        {
            if (!Player.IsAlive)
            {
                _focusAppliedTime = DateTime.MinValue;
                _hasCastEnrage = false;
                lblStatus.Text = "Status: Dead (Reset)";
                lblCurrentTarget.Text = "Target: None";
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

            if (chkEnableLoopEnrage.Checked && _focusAppliedTime != DateTime.MinValue)
            {
                double elapsed = (DateTime.Now - _focusAppliedTime).TotalSeconds;
                double triggerSec = (double)numTriggerSeconds.Value;

                if (!_hasCastEnrage)
                {
                    lblStatus.Text = $"Status: Active ({elapsed:F1}s)";
                    if (elapsed >= triggerSec)
                    {
                        string skillToUse = cmbSkill.SelectedItem?.ToString() ?? "5";
                        TriggerLoopEnrage(skillToUse);
                    }
                }
                else
                {
                    lblStatus.Text = $"Status: Triggered ({elapsed:F1}s)";
                }
            }
            else
            {
                lblStatus.Text = "Status: Idle";
            }
        }

        private async void TriggerLoopEnrage(string skillToUse)
        {
            _hasCastEnrage = true;
            bool success = await ExecuteSkillWithWait(skillToUse);
            if (!success && chkEnableLoopEnrage.Checked && _focusAppliedTime != DateTime.MinValue && Player.IsAlive)
            {
                _hasCastEnrage = false;
            }
        }

        private async Task<bool> ExecuteSkillWithWait(string index)
        {
            try
            {
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

        private void CodexEnrageForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }
    }
}

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

        private const string TauntSkill = "5";
        private const string TargetAura = "Focus";
        private const double TriggerSeconds = 5.0;
        private const double WatchdogSeconds = 10.5;

        private enum TauntState
        {
            Idle,
            WaitingForManualStart,
            WaitingForPartner,
            CountingDown,
            Casting
        }

        private TauntState _state = TauntState.Idle;
        private DateTime _turnStartTime = DateTime.MinValue;
        private DateTime _lastMyCastTime = DateTime.MinValue;
        private bool _isCasting = false;

        private CodexEnrageForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private void CodexEnrageForm_Load(object sender, EventArgs e)
        {
            // Initial load
        }

        private void rbTaunt_CheckedChanged(object sender, EventArgs e)
        {
            if (chkEnableLoopEnrage.Checked)
            {
                ResetCycle();
            }
        }

        private void chkEnableLoopEnrage_CheckedChanged(object sender, EventArgs e)
        {
            Flash.FlashCall2 -= LoopTauntPacketHandler;
            if (chkEnableLoopEnrage.Checked)
            {
                ResetCycle();
                Flash.FlashCall2 += LoopTauntPacketHandler;
            }
            else
            {
                _state = TauntState.Idle;
                lblStatus.Text = "Status: Idle";
            }
        }

        private void ResetCycle()
        {
            _turnStartTime = DateTime.MinValue;
            _lastMyCastTime = DateTime.MinValue;
            _isCasting = false;

            if (rbTaunt1.Checked)
            {
                // Taunt 1: Manual trigger by user the first time
                _state = TauntState.WaitingForManualStart;
                lblStatus.Text = "Status: Opening: Trigger Manual";
            }
            else
            {
                // Taunt 2: Passive wait for Taunt 1's Focus
                _state = TauntState.WaitingForPartner;
                lblStatus.Text = "Status: Waiting for Taunt 1...";
            }
        }

        private void LoopTauntPacketHandler(string function, params object[] args)
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
                            if (cmd == "aura+" || cmd == "auraUpdate")
                            {
                                bool focusFound = false;

                                // Check multiple auras array
                                if (action["auras"] is JArray auras)
                                {
                                    foreach (JObject aura in auras)
                                    {
                                        string name = aura["nam"]?.ToString();
                                        if (string.Equals(name, TargetAura, StringComparison.OrdinalIgnoreCase))
                                        {
                                            focusFound = true;
                                            break;
                                        }
                                    }
                                }

                                // Check single aura object
                                if (!focusFound && action["aura"] is JObject singleAura)
                                {
                                    string name = singleAura["nam"]?.ToString();
                                    if (string.Equals(name, TargetAura, StringComparison.OrdinalIgnoreCase))
                                    {
                                        focusFound = true;
                                    }
                                }

                                if (focusFound)
                                {
                                    OnFocusDetected();
                                }
                            }
                        }
                    }
                }
            }
            catch { }
        }

        private void OnFocusDetected()
        {
            DateTime now = DateTime.UtcNow;

            // 1. If Taunt 1 is waiting for the user's manual opening cast
            if (_state == TauntState.WaitingForManualStart)
            {
                // User just casted manual opening! Focus is now on the boss.
                _lastMyCastTime = now;
                _state = TauntState.WaitingForPartner;
                lblStatus.Text = "Status: Partner's Turn (Waiting Taunt 2)...";
                return;
            }

            // 2. If we just casted within the last 2.0s, this packet is our own Focus confirmation
            if (_lastMyCastTime != DateTime.MinValue && (now - _lastMyCastTime).TotalSeconds < 2.0)
            {
                _state = TauntState.WaitingForPartner;
                return;
            }

            // 3. Partner casted Focus!
            if (_state == TauntState.WaitingForPartner || _state == TauntState.Idle)
            {
                _turnStartTime = now;
                _state = TauntState.CountingDown;
            }
        }

        private void timerUpdate_Tick(object sender, EventArgs e)
        {
            if (!Player.IsAlive)
            {
                lblStatus.Text = "Status: Dead (Waiting respawn)";
                lblCurrentTarget.Text = "Target: None";
                return;
            }

            string rawTargetName = Player.GetTargetName;
            bool hasTarget = !string.IsNullOrEmpty(rawTargetName) && rawTargetName != "null";
            if (!hasTarget)
            {
                lblCurrentTarget.Text = "Target: None";
            }
            else
            {
                lblCurrentTarget.Text = "Target: " + rawTargetName.Replace("\"", "");
            }

            if (!chkEnableLoopEnrage.Checked) return;

            DateTime now = DateTime.UtcNow;

            // 1. Manual Opening phase for Taunt 1
            if (_state == TauntState.WaitingForManualStart)
            {
                lblStatus.Text = "Status: Opening: Trigger Manual";
                return;
            }

            // 2. Countdown phase: Counting 5 seconds from partner's Focus
            if (_state == TauntState.CountingDown)
            {
                double elapsed = (now - _turnStartTime).TotalSeconds;
                if (elapsed < TriggerSeconds)
                {
                    double remain = Math.Max(0, TriggerSeconds - elapsed);
                    lblStatus.Text = $"Status: Taunt in {remain:F1}s";
                }
                else
                {
                    _state = TauntState.Casting;
                    lblStatus.Text = "Status: Casting Taunt!";
                    _ = TriggerTauntCast();
                }
                return;
            }

            // 3. Waiting for Partner phase (+ Anti-stop Watchdog safety)
            if (_state == TauntState.WaitingForPartner)
            {
                if (_lastMyCastTime == DateTime.MinValue)
                {
                    lblStatus.Text = "Status: Waiting for Taunt 1...";
                }
                else
                {
                    double timeSinceMyCast = (now - _lastMyCastTime).TotalSeconds;
                    string partnerLabel = rbTaunt1.Checked ? "Taunt 2" : "Taunt 1";
                    lblStatus.Text = $"Status: Partner's Turn ({timeSinceMyCast:F1}s)";

                    // Anti-Stop Watchdog: If 10.5 seconds pass and partner missed taunt (lag/dc),
                    // emergency cast to save the team and keep cycle alive!
                    if (timeSinceMyCast >= WatchdogSeconds && !_isCasting)
                    {
                        _state = TauntState.Casting;
                        lblStatus.Text = "Status: Watchdog Emergency Taunt!";
                        _ = TriggerTauntCast();
                    }
                }
            }
        }

        private async Task TriggerTauntCast()
        {
            if (_isCasting) return;
            _isCasting = true;

            try
            {
                bool success = await ExecuteSkillWithRetry(TauntSkill);
                _lastMyCastTime = DateTime.UtcNow;
                _state = TauntState.WaitingForPartner;
            }
            finally
            {
                _isCasting = false;
            }
        }

        private async Task<bool> ExecuteSkillWithRetry(string index)
        {
            try
            {
                if (!Player.IsAlive) return false;

                // Ensure monster is targeted
                string target = Player.GetTargetName;
                if (string.IsNullOrEmpty(target) || target == "null")
                {
                    try
                    {
                        Flash.Call("AttackMonster", "*");
                    }
                    catch { }
                    await Task.Delay(100);
                }

                // Check cooldown and wait if small
                int cd = Player.SkillAvailable(index);
                if (cd > 0 && cd < 1200)
                {
                    await Task.Delay(cd);
                }

                // Cast and verify cooldown
                for (int i = 0; i < 6; i++)
                {
                    if (!Player.IsAlive || !chkEnableLoopEnrage.Checked) return false;

                    Player.ForceUseSkill(index);
                    await Task.Delay(120);

                    if (Player.SkillAvailable(index) > 0)
                    {
                        return true;
                    }
                }
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

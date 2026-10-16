using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Tools;

namespace Grimoire.UI
{
    public partial class CodexForm : DarkForm
    {
        public static CodexForm Instance { get; } = new CodexForm();

        private CodexForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private void CodexForm_Load(object sender, EventArgs e)
        {
            // Populate microphone devices
            cmbMicrophone.Items.Clear();
            List<string> mics = VoiceChatManager.GetMicrophoneDevices();
            if (mics.Count > 0)
            {
                foreach (var mic in mics)
                {
                    cmbMicrophone.Items.Add(mic);
                }
                cmbMicrophone.SelectedIndex = Math.Min(VoiceChatManager.Instance.selectedMicIndex, mics.Count - 1);
            }
            else
            {
                cmbMicrophone.Items.Add("No microphone detected");
                cmbMicrophone.SelectedIndex = 0;
            }

            // Sync manager states to UI
            chkEnableVoice.Checked = VoiceChatManager.Instance.voiceEnabled;
            chkMute.Checked = VoiceChatManager.Instance.isMuted;
            chkDeafen.Checked = VoiceChatManager.Instance.isDeafened;
            chkLoopback.Checked = VoiceChatManager.Instance.isLoopback;

            // Sync volume and boost trackbars
            int boostVal = Math.Max(0, Math.Min(300, (int)(VoiceChatManager.Instance.voiceBoost * 100f)));
            tbInputVol.Value = boostVal;
            lblInputVol.Text = $"Mic Boost (Input): {boostVal}%";

            int volVal = Math.Max(0, Math.Min(200, (int)(VoiceChatManager.Instance.voiceVolume * 100f)));
            tbOutputVol.Value = volVal;
            lblOutputVol.Text = $"Voice Volume (Output): {volVal}%";
        }

        private void chkEnableVoice_CheckedChanged(object sender, EventArgs e)
        {
            bool val = chkEnableVoice.Checked;
            VoiceChatManager.Instance.voiceEnabled = val;
            if (val)
            {
                if (!VoiceChatManager.Instance.isRunning)
                {
                    VoiceChatManager.Instance.StartVoice();
                }
            }
            else
            {
                if (VoiceChatManager.Instance.isRunning)
                {
                    VoiceChatManager.Instance.StopVoice();
                }
            }
        }

        private void cmbMicrophone_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmbMicrophone.SelectedIndex >= 0 && cmbMicrophone.Text != "No microphone detected")
            {
                VoiceChatManager.Instance.ChangeMicrophone(cmbMicrophone.SelectedIndex);
            }
        }

        private void chkMute_CheckedChanged(object sender, EventArgs e)
        {
            VoiceChatManager.Instance.isMuted = chkMute.Checked;
        }

        private void chkDeafen_CheckedChanged(object sender, EventArgs e)
        {
            VoiceChatManager.Instance.isDeafened = chkDeafen.Checked;
        }

        private void chkLoopback_CheckedChanged(object sender, EventArgs e)
        {
            VoiceChatManager.Instance.SetLoopback(chkLoopback.Checked);
        }

        private void tbInputVol_Scroll(object sender, EventArgs e)
        {
            float boost = tbInputVol.Value / 100f;
            VoiceChatManager.Instance.SetVoiceBoost(boost);
            lblInputVol.Text = $"Mic Boost (Input): {tbInputVol.Value}%";
        }

        private void tbOutputVol_Scroll(object sender, EventArgs e)
        {
            float vol = tbOutputVol.Value / 100f;
            VoiceChatManager.Instance.SetVoiceVolume(vol);
            lblOutputVol.Text = $"Voice Volume (Output): {tbOutputVol.Value}%";
        }

        private void timerUpdate_Tick(object sender, EventArgs e)
        {
            // Update Voice Chat UI
            if (VoiceChatManager.Instance.isRunning)
            {
                lblStatus.Text = $"Status: {VoiceChatManager.Instance.connectionStatus}";

                // Update VU Meter
                int levelVal = (int)(VoiceChatManager.Instance.micLevel * 100f);
                pbMicLevel.Value = Math.Min(100, Math.Max(0, levelVal));

                // Update Active Peers
                List<string> peers = VoiceChatManager.Instance.GetActivePeerNames();
                
                // Diff the items to avoid unnecessary flicker
                var currentItems = lstPeers.Items.Cast<string>().ToList();
                if (!currentItems.SequenceEqual(peers))
                {
                    lstPeers.Items.Clear();
                    foreach (var peer in peers)
                    {
                        lstPeers.Items.Add(peer);
                    }
                }

                // Invalidate list to redraw green active speaker indicator in real-time
                lstPeers.Invalidate();
            }
            else
            {
                lblStatus.Text = "Status: Disconnected";
                pbMicLevel.Value = 0;
                if (lstPeers.Items.Count > 0)
                {
                    lstPeers.Items.Clear();
                }
            }
        }

        private void lstPeers_DrawItem(object sender, DrawItemEventArgs e)
        {
            if (e.Index < 0 || e.Index >= lstPeers.Items.Count) return;

            string username = lstPeers.Items[e.Index]?.ToString() ?? "";
            bool isSpeaking = VoiceChatManager.Instance.IsPeerSpeaking(username);

            // Background
            bool isSelected = (e.State & DrawItemState.Selected) == DrawItemState.Selected;
            Color bg = isSelected ? Color.FromArgb(50, 50, 65) : Color.FromArgb(36, 36, 46);
            using (SolidBrush bgBrush = new SolidBrush(bg))
            {
                e.Graphics.FillRectangle(bgBrush, e.Bounds);
            }

            // Discord-style colors: Green when speaking (#57F287), light gray when quiet (#DCDCDC)
            Color textColor = isSpeaking ? Color.FromArgb(87, 242, 135) : Color.FromArgb(220, 220, 220);
            Color dotColor = isSpeaking ? Color.FromArgb(87, 242, 135) : Color.FromArgb(100, 100, 110);

            // Draw status dot
            int dotSize = 8;
            int dotX = e.Bounds.X + 6;
            int dotY = e.Bounds.Y + (e.Bounds.Height - dotSize) / 2;
            using (SolidBrush dotBrush = new SolidBrush(dotColor))
            {
                e.Graphics.FillEllipse(dotBrush, dotX, dotY, dotSize, dotSize);
            }

            // Draw username
            using (SolidBrush textBrush = new SolidBrush(textColor))
            using (Font textFont = new Font(e.Font.FontFamily, 9f, isSpeaking ? FontStyle.Bold : FontStyle.Regular))
            {
                int textX = dotX + dotSize + 6;
                int textY = e.Bounds.Y + (e.Bounds.Height - textFont.Height) / 2;
                e.Graphics.DrawString(username, textFont, textBrush, textX, textY);
            }
        }

        private void CodexForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }
    }
}

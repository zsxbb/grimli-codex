namespace Grimoire.UI
{
    partial class CodexForm
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.chkEnableVoice = new DarkUI.Controls.DarkCheckBox();
            this.cmbMicrophone = new DarkUI.Controls.DarkComboBox();
            this.lblMic = new DarkUI.Controls.DarkLabel();
            this.chkLoopback = new DarkUI.Controls.DarkCheckBox();
            this.chkDeafen = new DarkUI.Controls.DarkCheckBox();
            this.chkMute = new DarkUI.Controls.DarkCheckBox();
            this.lblInputVol = new DarkUI.Controls.DarkLabel();
            this.tbInputVol = new System.Windows.Forms.TrackBar();
            this.lblOutputVol = new DarkUI.Controls.DarkLabel();
            this.tbOutputVol = new System.Windows.Forms.TrackBar();
            this.lblStatus = new DarkUI.Controls.DarkLabel();
            this.pbMicLevel = new System.Windows.Forms.ProgressBar();
            this.gbPeers = new DarkUI.Controls.DarkGroupBox();
            this.lstPeers = new System.Windows.Forms.ListBox();
            this.timerUpdate = new System.Windows.Forms.Timer(this.components);

            ((System.ComponentModel.ISupportInitialize)(this.tbInputVol)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbOutputVol)).BeginInit();
            this.gbPeers.SuspendLayout();
            this.SuspendLayout();

            // 
            // chkEnableVoice
            // 
            this.chkEnableVoice.AutoSize = true;
            this.chkEnableVoice.Location = new System.Drawing.Point(10, 10);
            this.chkEnableVoice.Name = "chkEnableVoice";
            this.chkEnableVoice.Size = new System.Drawing.Size(210, 17);
            this.chkEnableVoice.TabIndex = 0;
            this.chkEnableVoice.Text = "Enable Voice Chat";
            this.chkEnableVoice.CheckedChanged += new System.EventHandler(this.chkEnableVoice_CheckedChanged);

            // 
            // chkMute
            // 
            this.chkMute.AutoSize = true;
            this.chkMute.Location = new System.Drawing.Point(10, 32);
            this.chkMute.Name = "chkMute";
            this.chkMute.Size = new System.Drawing.Size(55, 17);
            this.chkMute.TabIndex = 1;
            this.chkMute.Text = "Mute";
            this.chkMute.CheckedChanged += new System.EventHandler(this.chkMute_CheckedChanged);

            // 
            // chkDeafen
            // 
            this.chkDeafen.AutoSize = true;
            this.chkDeafen.Location = new System.Drawing.Point(75, 32);
            this.chkDeafen.Name = "chkDeafen";
            this.chkDeafen.Size = new System.Drawing.Size(65, 17);
            this.chkDeafen.TabIndex = 2;
            this.chkDeafen.Text = "Deafen";
            this.chkDeafen.CheckedChanged += new System.EventHandler(this.chkDeafen_CheckedChanged);

            // 
            // chkLoopback
            // 
            this.chkLoopback.AutoSize = true;
            this.chkLoopback.Location = new System.Drawing.Point(150, 32);
            this.chkLoopback.Name = "chkLoopback";
            this.chkLoopback.Size = new System.Drawing.Size(60, 17);
            this.chkLoopback.TabIndex = 7;
            this.chkLoopback.Text = "Check";
            this.chkLoopback.CheckedChanged += new System.EventHandler(this.chkLoopback_CheckedChanged);

            // 
            // lblMic
            // 
            this.lblMic.AutoSize = true;
            this.lblMic.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblMic.Location = new System.Drawing.Point(10, 56);
            this.lblMic.Name = "lblMic";
            this.lblMic.Size = new System.Drawing.Size(66, 13);
            this.lblMic.TabIndex = 3;
            this.lblMic.Text = "Microphone:";

            // 
            // cmbMicrophone
            // 
            this.cmbMicrophone.FormattingEnabled = true;
            this.cmbMicrophone.Location = new System.Drawing.Point(10, 72);
            this.cmbMicrophone.Name = "cmbMicrophone";
            this.cmbMicrophone.Size = new System.Drawing.Size(210, 21);
            this.cmbMicrophone.TabIndex = 4;
            this.cmbMicrophone.SelectedIndexChanged += new System.EventHandler(this.cmbMicrophone_SelectedIndexChanged);

            // 
            // pbMicLevel
            // 
            this.pbMicLevel.Location = new System.Drawing.Point(10, 98);
            this.pbMicLevel.Name = "pbMicLevel";
            this.pbMicLevel.Size = new System.Drawing.Size(210, 8);
            this.pbMicLevel.TabIndex = 10;
            this.pbMicLevel.Style = System.Windows.Forms.ProgressBarStyle.Continuous;

            // 
            // lblInputVol
            // 
            this.lblInputVol.AutoSize = true;
            this.lblInputVol.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblInputVol.Location = new System.Drawing.Point(10, 114);
            this.lblInputVol.Name = "lblInputVol";
            this.lblInputVol.Size = new System.Drawing.Size(126, 13);
            this.lblInputVol.TabIndex = 13;
            this.lblInputVol.Text = "Mic Boost (Input): 100%";

            // 
            // tbInputVol
            // 
            this.tbInputVol.AutoSize = false;
            this.tbInputVol.Location = new System.Drawing.Point(10, 130);
            this.tbInputVol.Maximum = 300;
            this.tbInputVol.Minimum = 0;
            this.tbInputVol.Name = "tbInputVol";
            this.tbInputVol.Size = new System.Drawing.Size(210, 24);
            this.tbInputVol.TabIndex = 14;
            this.tbInputVol.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbInputVol.Value = 100;
            this.tbInputVol.Scroll += new System.EventHandler(this.tbInputVol_Scroll);

            // 
            // lblOutputVol
            // 
            this.lblOutputVol.AutoSize = true;
            this.lblOutputVol.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblOutputVol.Location = new System.Drawing.Point(10, 160);
            this.lblOutputVol.Name = "lblOutputVol";
            this.lblOutputVol.Size = new System.Drawing.Size(148, 13);
            this.lblOutputVol.TabIndex = 15;
            this.lblOutputVol.Text = "Voice Volume (Output): 100%";

            // 
            // tbOutputVol
            // 
            this.tbOutputVol.AutoSize = false;
            this.tbOutputVol.Location = new System.Drawing.Point(10, 176);
            this.tbOutputVol.Maximum = 200;
            this.tbOutputVol.Minimum = 0;
            this.tbOutputVol.Name = "tbOutputVol";
            this.tbOutputVol.Size = new System.Drawing.Size(210, 24);
            this.tbOutputVol.TabIndex = 16;
            this.tbOutputVol.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbOutputVol.Value = 100;
            this.tbOutputVol.Scroll += new System.EventHandler(this.tbOutputVol_Scroll);

            // 
            // lblStatus
            // 
            this.lblStatus.AutoSize = true;
            this.lblStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblStatus.Location = new System.Drawing.Point(10, 206);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(210, 13);
            this.lblStatus.TabIndex = 11;
            this.lblStatus.Text = "Status: Disconnected";

            // 
            // gbPeers
            // 
            this.gbPeers.Controls.Add(this.lstPeers);
            this.gbPeers.Location = new System.Drawing.Point(10, 226);
            this.gbPeers.Name = "gbPeers";
            this.gbPeers.Size = new System.Drawing.Size(210, 218);
            this.gbPeers.TabIndex = 12;
            this.gbPeers.TabStop = false;
            this.gbPeers.Text = "Active Peers";

            // 
            // lstPeers
            // 
            this.lstPeers.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(36)))), ((int)(((byte)(36)))), ((int)(((byte)(46)))));
            this.lstPeers.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.lstPeers.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.lstPeers.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lstPeers.FormattingEnabled = true;
            this.lstPeers.ItemHeight = 22;
            this.lstPeers.Location = new System.Drawing.Point(6, 18);
            this.lstPeers.Name = "lstPeers";
            this.lstPeers.Size = new System.Drawing.Size(198, 194);
            this.lstPeers.TabIndex = 0;
            this.lstPeers.DrawItem += new System.Windows.Forms.DrawItemEventHandler(this.lstPeers_DrawItem);

            // 
            // timerUpdate
            // 
            this.timerUpdate.Enabled = true;
            this.timerUpdate.Interval = 200;
            this.timerUpdate.Tick += new System.EventHandler(this.timerUpdate_Tick);

            // 
            // CodexForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(28)))), ((int)(((byte)(38)))));
            this.ClientSize = new System.Drawing.Size(230, 455);
            this.Controls.Add(this.chkEnableVoice);
            this.Controls.Add(this.chkMute);
            this.Controls.Add(this.chkDeafen);
            this.Controls.Add(this.lblMic);
            this.Controls.Add(this.cmbMicrophone);
            this.Controls.Add(this.chkLoopback);
            this.Controls.Add(this.pbMicLevel);
            this.Controls.Add(this.lblInputVol);
            this.Controls.Add(this.tbInputVol);
            this.Controls.Add(this.lblOutputVol);
            this.Controls.Add(this.tbOutputVol);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.gbPeers);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "CodexForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Voice Chat";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.CodexForm_FormClosing);
            this.Load += new System.EventHandler(this.CodexForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.tbInputVol)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbOutputVol)).EndInit();
            this.gbPeers.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        #endregion

        private DarkUI.Controls.DarkCheckBox chkEnableVoice;
        private DarkUI.Controls.DarkComboBox cmbMicrophone;
        private DarkUI.Controls.DarkLabel lblMic;
        private DarkUI.Controls.DarkCheckBox chkLoopback;
        private DarkUI.Controls.DarkCheckBox chkDeafen;
        private DarkUI.Controls.DarkCheckBox chkMute;
        private DarkUI.Controls.DarkLabel lblInputVol;
        private System.Windows.Forms.TrackBar tbInputVol;
        private DarkUI.Controls.DarkLabel lblOutputVol;
        private System.Windows.Forms.TrackBar tbOutputVol;
        private DarkUI.Controls.DarkLabel lblStatus;
        private System.Windows.Forms.ProgressBar pbMicLevel;
        private DarkUI.Controls.DarkGroupBox gbPeers;
        private System.Windows.Forms.ListBox lstPeers;
        private System.Windows.Forms.Timer timerUpdate;
    }
}

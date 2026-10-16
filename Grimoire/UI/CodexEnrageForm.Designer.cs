/*  */using System.Windows.Forms;

namespace Grimoire.UI
{
    partial class CodexEnrageForm
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
            this.chkEnableLoopEnrage = new DarkUI.Controls.DarkCheckBox();
            this.lblStatus = new DarkUI.Controls.DarkLabel();
            this.lblCurrentTarget = new DarkUI.Controls.DarkLabel();
            this.lblAuraName = new DarkUI.Controls.DarkLabel();
            this.txtAuraName = new DarkUI.Controls.DarkTextBox();
            this.lblSkill = new DarkUI.Controls.DarkLabel();
            this.cmbSkill = new DarkUI.Controls.DarkComboBox();
            this.lblTriggerSeconds = new DarkUI.Controls.DarkLabel();
            this.numTriggerSeconds = new DarkUI.Controls.DarkNumericUpDown();
            this.timerUpdate = new System.Windows.Forms.Timer(this.components);

            ((System.ComponentModel.ISupportInitialize)(this.numTriggerSeconds)).BeginInit();
            this.SuspendLayout();

            // 
            // chkEnableLoopEnrage
            // 
            this.chkEnableLoopEnrage.AutoSize = true;
            this.chkEnableLoopEnrage.Location = new System.Drawing.Point(10, 10);
            this.chkEnableLoopEnrage.Name = "chkEnableLoopEnrage";
            this.chkEnableLoopEnrage.Size = new System.Drawing.Size(200, 17);
            this.chkEnableLoopEnrage.TabIndex = 0;
            this.chkEnableLoopEnrage.Text = "Enable Loop Aura";
            this.chkEnableLoopEnrage.CheckedChanged += new System.EventHandler(this.chkEnableLoopEnrage_CheckedChanged);

            // 
            // lblStatus
            // 
            this.lblStatus.AutoSize = true;
            this.lblStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblStatus.Location = new System.Drawing.Point(10, 32);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(200, 13);
            this.lblStatus.TabIndex = 1;
            this.lblStatus.Text = "Status: Idle";

            // 
            // lblCurrentTarget
            // 
            this.lblCurrentTarget.AutoSize = true;
            this.lblCurrentTarget.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(200)))), ((int)(((byte)(80)))));
            this.lblCurrentTarget.Location = new System.Drawing.Point(10, 50);
            this.lblCurrentTarget.Name = "lblCurrentTarget";
            this.lblCurrentTarget.Size = new System.Drawing.Size(200, 13);
            this.lblCurrentTarget.TabIndex = 8;
            this.lblCurrentTarget.Text = "Target: None";

            // 
            // lblAuraName
            // 
            this.lblAuraName.AutoSize = true;
            this.lblAuraName.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblAuraName.Location = new System.Drawing.Point(10, 75);
            this.lblAuraName.Name = "lblAuraName";
            this.lblAuraName.Size = new System.Drawing.Size(63, 13);
            this.lblAuraName.TabIndex = 2;
            this.lblAuraName.Text = "Aura Name:";

            // 
            // txtAuraName
            // 
            this.txtAuraName.Location = new System.Drawing.Point(10, 92);
            this.txtAuraName.Name = "txtAuraName";
            this.txtAuraName.Size = new System.Drawing.Size(200, 20);
            this.txtAuraName.TabIndex = 3;
            this.txtAuraName.Text = "Focus";

            // 
            // lblSkill
            // 
            this.lblSkill.AutoSize = true;
            this.lblSkill.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblSkill.Location = new System.Drawing.Point(10, 118);
            this.lblSkill.Name = "lblSkill";
            this.lblSkill.Size = new System.Drawing.Size(68, 13);
            this.lblSkill.TabIndex = 4;
            this.lblSkill.Text = "Skill Action:";

            // 
            // cmbSkill
            // 
            this.cmbSkill.FormattingEnabled = true;
            this.cmbSkill.Items.AddRange(new object[] { "1", "2", "3", "4", "5" });
            this.cmbSkill.Location = new System.Drawing.Point(10, 135);
            this.cmbSkill.Name = "cmbSkill";
            this.cmbSkill.Size = new System.Drawing.Size(95, 21);
            this.cmbSkill.TabIndex = 5;

            // 
            // lblTriggerSeconds
            // 
            this.lblTriggerSeconds.AutoSize = true;
            this.lblTriggerSeconds.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblTriggerSeconds.Location = new System.Drawing.Point(115, 118);
            this.lblTriggerSeconds.Name = "lblTriggerSeconds";
            this.lblTriggerSeconds.Size = new System.Drawing.Size(71, 13);
            this.lblTriggerSeconds.TabIndex = 6;
            this.lblTriggerSeconds.Text = "Trigger at (s):";

            // 
            this.numTriggerSeconds.DecimalPlaces = 0;
            this.numTriggerSeconds.Increment = new decimal(new int[] { 1, 0, 0, 0 });
            this.numTriggerSeconds.Location = new System.Drawing.Point(115, 135);
            this.numTriggerSeconds.Maximum = new decimal(new int[] { 60, 0, 0, 0 });
            this.numTriggerSeconds.Minimum = new decimal(new int[] { 1, 0, 0, 0 });
            this.numTriggerSeconds.Name = "numTriggerSeconds";
            this.numTriggerSeconds.Size = new System.Drawing.Size(95, 20);
            this.numTriggerSeconds.TabIndex = 7;
            this.numTriggerSeconds.Value = new decimal(new int[] { 5, 0, 0, 0 });

            // 
            // timerUpdate
            // 
            this.timerUpdate.Enabled = true;
            this.timerUpdate.Interval = 100;
            this.timerUpdate.Tick += new System.EventHandler(this.timerUpdate_Tick);

            // 
            // CodexEnrageForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(28)))), ((int)(((byte)(38)))));
            this.ClientSize = new System.Drawing.Size(220, 175);
            this.Controls.Add(this.chkEnableLoopEnrage);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.lblCurrentTarget);
            this.Controls.Add(this.lblAuraName);
            this.Controls.Add(this.txtAuraName);
            this.Controls.Add(this.lblSkill);
            this.Controls.Add(this.cmbSkill);
            this.Controls.Add(this.lblTriggerSeconds);
            this.Controls.Add(this.numTriggerSeconds);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "CodexEnrageForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Loop Aura";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.CodexEnrageForm_FormClosing);
            this.Load += new System.EventHandler(this.CodexEnrageForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.numTriggerSeconds)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        #endregion

        private DarkUI.Controls.DarkCheckBox chkEnableLoopEnrage;
        private DarkUI.Controls.DarkLabel lblStatus;
        private DarkUI.Controls.DarkLabel lblCurrentTarget;
        private DarkUI.Controls.DarkLabel lblAuraName;
        private DarkUI.Controls.DarkTextBox txtAuraName;
        private DarkUI.Controls.DarkLabel lblSkill;
        private DarkUI.Controls.DarkComboBox cmbSkill;
        private DarkUI.Controls.DarkLabel lblTriggerSeconds;
        private DarkUI.Controls.DarkNumericUpDown numTriggerSeconds;
        private System.Windows.Forms.Timer timerUpdate;
    }
}

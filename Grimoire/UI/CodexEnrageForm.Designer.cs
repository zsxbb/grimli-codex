using System.Windows.Forms;

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
            this.rbTaunt1 = new DarkUI.Controls.DarkRadioButton();
            this.rbTaunt2 = new DarkUI.Controls.DarkRadioButton();
            this.timerUpdate = new System.Windows.Forms.Timer(this.components);

            this.SuspendLayout();

            // 
            // chkEnableLoopEnrage
            // 
            this.chkEnableLoopEnrage.AutoSize = true;
            this.chkEnableLoopEnrage.Location = new System.Drawing.Point(12, 10);
            this.chkEnableLoopEnrage.Name = "chkEnableLoopEnrage";
            this.chkEnableLoopEnrage.Size = new System.Drawing.Size(180, 17);
            this.chkEnableLoopEnrage.TabIndex = 0;
            this.chkEnableLoopEnrage.Text = "Enable Loop Taunt";
            this.chkEnableLoopEnrage.CheckedChanged += new System.EventHandler(this.chkEnableLoopEnrage_CheckedChanged);

            // 
            // lblStatus
            // 
            this.lblStatus.AutoSize = true;
            this.lblStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblStatus.Location = new System.Drawing.Point(12, 32);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(185, 13);
            this.lblStatus.TabIndex = 1;
            this.lblStatus.Text = "Status: Idle";

            // 
            // lblCurrentTarget
            // 
            this.lblCurrentTarget.AutoSize = true;
            this.lblCurrentTarget.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(200)))), ((int)(((byte)(80)))));
            this.lblCurrentTarget.Location = new System.Drawing.Point(12, 50);
            this.lblCurrentTarget.Name = "lblCurrentTarget";
            this.lblCurrentTarget.Size = new System.Drawing.Size(185, 13);
            this.lblCurrentTarget.TabIndex = 2;
            this.lblCurrentTarget.Text = "Target: None";

            // 
            // rbTaunt1
            // 
            this.rbTaunt1.AutoSize = true;
            this.rbTaunt1.Checked = true;
            this.rbTaunt1.Location = new System.Drawing.Point(15, 74);
            this.rbTaunt1.Name = "rbTaunt1";
            this.rbTaunt1.Size = new System.Drawing.Size(75, 17);
            this.rbTaunt1.TabIndex = 3;
            this.rbTaunt1.TabStop = true;
            this.rbTaunt1.Text = "Taunt 1";
            this.rbTaunt1.CheckedChanged += new System.EventHandler(this.rbTaunt_CheckedChanged);

            // 
            // rbTaunt2
            // 
            this.rbTaunt2.AutoSize = true;
            this.rbTaunt2.Location = new System.Drawing.Point(110, 74);
            this.rbTaunt2.Name = "rbTaunt2";
            this.rbTaunt2.Size = new System.Drawing.Size(75, 17);
            this.rbTaunt2.TabIndex = 4;
            this.rbTaunt2.Text = "Taunt 2";
            this.rbTaunt2.CheckedChanged += new System.EventHandler(this.rbTaunt_CheckedChanged);

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
            this.ClientSize = new System.Drawing.Size(205, 105);
            this.Controls.Add(this.chkEnableLoopEnrage);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.lblCurrentTarget);
            this.Controls.Add(this.rbTaunt1);
            this.Controls.Add(this.rbTaunt2);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "CodexEnrageForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Loop Taunt";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.CodexEnrageForm_FormClosing);
            this.Load += new System.EventHandler(this.CodexEnrageForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        #endregion

        private DarkUI.Controls.DarkCheckBox chkEnableLoopEnrage;
        private DarkUI.Controls.DarkLabel lblStatus;
        private DarkUI.Controls.DarkLabel lblCurrentTarget;
        private DarkUI.Controls.DarkRadioButton rbTaunt1;
        private DarkUI.Controls.DarkRadioButton rbTaunt2;
        private System.Windows.Forms.Timer timerUpdate;
    }
}

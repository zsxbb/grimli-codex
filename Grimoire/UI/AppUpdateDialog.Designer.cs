namespace Grimoire.UI
{
    partial class AppUpdateDialog
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
            this.lblTitle = new DarkUI.Controls.DarkLabel();
            this.lblStatus = new DarkUI.Controls.DarkLabel();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.btnCancel = new DarkUI.Controls.DarkButton();
            this.SuspendLayout();
            // 
            // lblTitle
            // 
            this.lblTitle.AutoSize = true;
            this.lblTitle.Font = new System.Drawing.Font("Segoe UI", 10.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTitle.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblTitle.Location = new System.Drawing.Point(16, 16);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(262, 19);
            this.lblTitle.TabIndex = 0;
            this.lblTitle.Text = "Downloading Grimlite Li x CODEX...";
            // 
            // lblStatus
            // 
            this.lblStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(170)))), ((int)(((byte)(170)))), ((int)(((byte)(180)))));
            this.lblStatus.Location = new System.Drawing.Point(16, 45);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(378, 20);
            this.lblStatus.TabIndex = 1;
            this.lblStatus.Text = "Connecting to GitHub...";
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(19, 70);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(375, 20);
            this.progressBar.TabIndex = 2;
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(304, 105);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Padding = new System.Windows.Forms.Padding(5);
            this.btnCancel.Size = new System.Drawing.Size(90, 26);
            this.btnCancel.TabIndex = 3;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // AppUpdateDialog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(36)))), ((int)(((byte)(36)))), ((int)(((byte)(46)))));
            this.ClientSize = new System.Drawing.Size(414, 146);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.lblTitle);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "AppUpdateDialog";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Updating Application";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.AppUpdateDialog_FormClosing);
            this.Load += new System.EventHandler(this.AppUpdateDialog_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DarkUI.Controls.DarkLabel lblTitle;
        private DarkUI.Controls.DarkLabel lblStatus;
        private System.Windows.Forms.ProgressBar progressBar;
        private DarkUI.Controls.DarkButton btnCancel;
    }
}

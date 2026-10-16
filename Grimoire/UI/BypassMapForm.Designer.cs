namespace Grimoire.UI
{
    partial class BypassMapForm
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

        private void InitializeComponent()
        {
            this.btnBypassAll = new DarkUI.Controls.DarkButton();
            this.SuspendLayout();
            // 
            // btnBypassAll
            // 
            this.btnBypassAll.Checked = false;
            this.btnBypassAll.Location = new System.Drawing.Point(12, 12);
            this.btnBypassAll.Name = "btnBypassAll";
            this.btnBypassAll.Size = new System.Drawing.Size(260, 35);
            this.btnBypassAll.TabIndex = 0;
            this.btnBypassAll.Text = "Bypass All Storylines";
            this.btnBypassAll.Click += new System.EventHandler(this.btnBypassAll_Click);
            // 
            // BypassMapForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.ClientSize = new System.Drawing.Size(284, 59);
            this.Controls.Add(this.btnBypassAll);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "BypassMapForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Bypass Map";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.BypassMapForm_FormClosing);
            this.ResumeLayout(false);
        }

        private DarkUI.Controls.DarkButton btnBypassAll;
    }
}

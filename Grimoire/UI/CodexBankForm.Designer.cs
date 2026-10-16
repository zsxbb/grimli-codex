namespace Grimoire.UI
{
    partial class CodexBankForm
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
            this.lblHeaderTitle = new DarkUI.Controls.DarkLabel();
            this.lblVersionInfo = new DarkUI.Controls.DarkLabel();
            this.btnCheckAppUpdate = new DarkUI.Controls.DarkButton();
            this.lvScripts = new System.Windows.Forms.ListView();
            this.colName = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.colCategory = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.colStatus = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.colDescription = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lblStatus = new DarkUI.Controls.DarkLabel();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.btnSyncAll = new DarkUI.Controls.DarkButton();
            this.btnSyncSelected = new DarkUI.Controls.DarkButton();
            this.btnRefresh = new DarkUI.Controls.DarkButton();
            this.btnOpenFolder = new DarkUI.Controls.DarkButton();
            this.SuspendLayout();
            // 
            // lblHeaderTitle
            // 
            this.lblHeaderTitle.AutoSize = true;
            this.lblHeaderTitle.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblHeaderTitle.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblHeaderTitle.Location = new System.Drawing.Point(12, 12);
            this.lblHeaderTitle.Name = "lblHeaderTitle";
            this.lblHeaderTitle.Size = new System.Drawing.Size(193, 21);
            this.lblHeaderTitle.TabIndex = 0;
            this.lblHeaderTitle.Text = "Codex Cloud Script Bank";
            // 
            // lblVersionInfo
            // 
            this.lblVersionInfo.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblVersionInfo.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(160)))), ((int)(((byte)(160)))), ((int)(((byte)(170)))));
            this.lblVersionInfo.Location = new System.Drawing.Point(340, 15);
            this.lblVersionInfo.Name = "lblVersionInfo";
            this.lblVersionInfo.Size = new System.Drawing.Size(200, 20);
            this.lblVersionInfo.TabIndex = 1;
            this.lblVersionInfo.Text = "App Version: 5.1";
            this.lblVersionInfo.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // btnCheckAppUpdate
            // 
            this.btnCheckAppUpdate.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCheckAppUpdate.Location = new System.Drawing.Point(546, 12);
            this.btnCheckAppUpdate.Name = "btnCheckAppUpdate";
            this.btnCheckAppUpdate.Padding = new System.Windows.Forms.Padding(5);
            this.btnCheckAppUpdate.Size = new System.Drawing.Size(116, 25);
            this.btnCheckAppUpdate.TabIndex = 2;
            this.btnCheckAppUpdate.Text = "Check App Update";
            this.btnCheckAppUpdate.Click += new System.EventHandler(this.btnCheckAppUpdate_Click);
            // 
            // lvScripts
            // 
            this.lvScripts.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lvScripts.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.lvScripts.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lvScripts.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.colName,
            this.colCategory,
            this.colStatus,
            this.colDescription});
            this.lvScripts.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lvScripts.FullRowSelect = true;
            this.lvScripts.GridLines = false;
            this.lvScripts.HideSelection = false;
            this.lvScripts.Location = new System.Drawing.Point(12, 45);
            this.lvScripts.Name = "lvScripts";
            this.lvScripts.Size = new System.Drawing.Size(650, 310);
            this.lvScripts.TabIndex = 3;
            this.lvScripts.UseCompatibleStateImageBehavior = false;
            this.lvScripts.View = System.Windows.Forms.View.Details;
            // 
            // colName
            // 
            this.colName.Text = "Script Name";
            this.colName.Width = 200;
            // 
            // colCategory
            // 
            this.colCategory.Text = "Category";
            this.colCategory.Width = 90;
            // 
            // colStatus
            // 
            this.colStatus.Text = "Status";
            this.colStatus.Width = 120;
            // 
            // colDescription
            // 
            this.colDescription.Text = "Description";
            this.colDescription.Width = 230;
            // 
            // lblStatus
            // 
            this.lblStatus.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.lblStatus.AutoSize = true;
            this.lblStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.lblStatus.Location = new System.Drawing.Point(12, 362);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(41, 13);
            this.lblStatus.TabIndex = 4;
            this.lblStatus.Text = "Ready.";
            // 
            // progressBar
            // 
            this.progressBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.progressBar.Location = new System.Drawing.Point(12, 381);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(650, 15);
            this.progressBar.TabIndex = 5;
            // 
            // btnSyncAll
            // 
            this.btnSyncAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnSyncAll.Location = new System.Drawing.Point(12, 406);
            this.btnSyncAll.Name = "btnSyncAll";
            this.btnSyncAll.Padding = new System.Windows.Forms.Padding(5);
            this.btnSyncAll.Size = new System.Drawing.Size(130, 30);
            this.btnSyncAll.TabIndex = 6;
            this.btnSyncAll.Text = "Sync All Scripts";
            this.btnSyncAll.Click += new System.EventHandler(this.btnSyncAll_Click);
            // 
            // btnSyncSelected
            // 
            this.btnSyncSelected.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnSyncSelected.Location = new System.Drawing.Point(148, 406);
            this.btnSyncSelected.Name = "btnSyncSelected";
            this.btnSyncSelected.Padding = new System.Windows.Forms.Padding(5);
            this.btnSyncSelected.Size = new System.Drawing.Size(120, 30);
            this.btnSyncSelected.TabIndex = 7;
            this.btnSyncSelected.Text = "Sync Selected";
            this.btnSyncSelected.Click += new System.EventHandler(this.btnSyncSelected_Click);
            // 
            // btnRefresh
            // 
            this.btnRefresh.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnRefresh.Location = new System.Drawing.Point(404, 406);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Padding = new System.Windows.Forms.Padding(5);
            this.btnRefresh.Size = new System.Drawing.Size(100, 30);
            this.btnRefresh.TabIndex = 8;
            this.btnRefresh.Text = "Refresh";
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // btnOpenFolder
            // 
            this.btnOpenFolder.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnOpenFolder.Location = new System.Drawing.Point(510, 406);
            this.btnOpenFolder.Name = "btnOpenFolder";
            this.btnOpenFolder.Padding = new System.Windows.Forms.Padding(5);
            this.btnOpenFolder.Size = new System.Drawing.Size(152, 30);
            this.btnOpenFolder.TabIndex = 9;
            this.btnOpenFolder.Text = "Open Bank Folder";
            this.btnOpenFolder.Click += new System.EventHandler(this.btnOpenFolder_Click);
            // 
            // CodexBankForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(36)))), ((int)(((byte)(36)))), ((int)(((byte)(46)))));
            this.ClientSize = new System.Drawing.Size(674, 448);
            this.Controls.Add(this.btnOpenFolder);
            this.Controls.Add(this.btnRefresh);
            this.Controls.Add(this.btnSyncSelected);
            this.Controls.Add(this.btnSyncAll);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.lvScripts);
            this.Controls.Add(this.btnCheckAppUpdate);
            this.Controls.Add(this.lblVersionInfo);
            this.Controls.Add(this.lblHeaderTitle);
            this.MinimumSize = new System.Drawing.Size(600, 400);
            this.Name = "CodexBankForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Codex Script Bank & Updater";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.CodexBankForm_FormClosing);
            this.Load += new System.EventHandler(this.CodexBankForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DarkUI.Controls.DarkLabel lblHeaderTitle;
        private DarkUI.Controls.DarkLabel lblVersionInfo;
        private DarkUI.Controls.DarkButton btnCheckAppUpdate;
        private System.Windows.Forms.ListView lvScripts;
        private System.Windows.Forms.ColumnHeader colName;
        private System.Windows.Forms.ColumnHeader colCategory;
        private System.Windows.Forms.ColumnHeader colStatus;
        private System.Windows.Forms.ColumnHeader colDescription;
        private DarkUI.Controls.DarkLabel lblStatus;
        private System.Windows.Forms.ProgressBar progressBar;
        private DarkUI.Controls.DarkButton btnSyncAll;
        private DarkUI.Controls.DarkButton btnSyncSelected;
        private DarkUI.Controls.DarkButton btnRefresh;
        private DarkUI.Controls.DarkButton btnOpenFolder;
    }
}

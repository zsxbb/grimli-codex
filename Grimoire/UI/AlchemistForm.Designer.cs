namespace Grimoire.UI
{
    partial class AlchemistForm
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
            this.lblSearch = new DarkUI.Controls.DarkLabel();
            this.txtSearch = new DarkUI.Controls.DarkTextBox();
            this.cmbPotions = new DarkUI.Controls.DarkComboBox();
            this.pnlMaterials = new System.Windows.Forms.Panel();
            this.lblBoxHeader = new System.Windows.Forms.Label();
            this.lblCatalystTitle = new DarkUI.Controls.DarkLabel();
            this.lblCatalystStatus = new DarkUI.Controls.DarkLabel();
            this.lblReagent1Title = new DarkUI.Controls.DarkLabel();
            this.lblReagent1Status = new DarkUI.Controls.DarkLabel();
            this.lblReagent2Title = new DarkUI.Controls.DarkLabel();
            this.lblReagent2Status = new DarkUI.Controls.DarkLabel();
            this.lblMaxBrews = new DarkUI.Controls.DarkLabel();
            this.btnRefresh = new System.Windows.Forms.Button();
            this.lblTarget = new DarkUI.Controls.DarkLabel();
            this.numTarget = new DarkUI.Controls.DarkNumericUpDown();
            this.chkStopIfOut = new DarkUI.Controls.DarkCheckBox();
            this.btnStartStop = new DarkUI.Controls.DarkButton();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.lblStatus = new DarkUI.Controls.DarkLabel();
            this.pnlMaterials.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numTarget)).BeginInit();
            this.SuspendLayout();
            // 
            // lblSearch
            // 
            this.lblSearch.AutoSize = true;
            this.lblSearch.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblSearch.Location = new System.Drawing.Point(12, 10);
            this.lblSearch.Name = "lblSearch";
            this.lblSearch.Size = new System.Drawing.Size(76, 13);
            this.lblSearch.TabIndex = 0;
            this.lblSearch.Text = "Search Potion:";
            // 
            // txtSearch
            // 
            this.txtSearch.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(140)))), ((int)(((byte)(140)))), ((int)(((byte)(140)))));
            this.txtSearch.Location = new System.Drawing.Point(12, 28);
            this.txtSearch.Name = "txtSearch";
            this.txtSearch.Size = new System.Drawing.Size(320, 20);
            this.txtSearch.TabIndex = 1;
            this.txtSearch.Text = "Search...";
            this.txtSearch.TextChanged += new System.EventHandler(this.txtSearch_TextChanged);
            this.txtSearch.Enter += new System.EventHandler(this.txtSearch_Enter);
            this.txtSearch.Leave += new System.EventHandler(this.txtSearch_Leave);
            // 
            // cmbPotions
            // 
            this.cmbPotions.FormattingEnabled = true;
            this.cmbPotions.Location = new System.Drawing.Point(12, 54);
            this.cmbPotions.Name = "cmbPotions";
            this.cmbPotions.Size = new System.Drawing.Size(320, 21);
            this.cmbPotions.TabIndex = 2;
            this.cmbPotions.SelectedIndexChanged += new System.EventHandler(this.cmbPotions_SelectedIndexChanged);
            // 
            // pnlMaterials
            // 
            this.pnlMaterials.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.pnlMaterials.Controls.Add(this.lblBoxHeader);
            this.pnlMaterials.Controls.Add(this.lblCatalystTitle);
            this.pnlMaterials.Controls.Add(this.lblCatalystStatus);
            this.pnlMaterials.Controls.Add(this.lblReagent1Title);
            this.pnlMaterials.Controls.Add(this.lblReagent1Status);
            this.pnlMaterials.Controls.Add(this.lblReagent2Title);
            this.pnlMaterials.Controls.Add(this.lblReagent2Status);
            this.pnlMaterials.Controls.Add(this.lblMaxBrews);
            this.pnlMaterials.Controls.Add(this.btnRefresh);
            this.pnlMaterials.Location = new System.Drawing.Point(12, 82);
            this.pnlMaterials.Name = "pnlMaterials";
            this.pnlMaterials.Size = new System.Drawing.Size(320, 154);
            this.pnlMaterials.TabIndex = 3;
            this.pnlMaterials.Paint += new System.Windows.Forms.PaintEventHandler(this.pnlMaterials_Paint);
            // 
            // lblBoxHeader
            // 
            this.lblBoxHeader.AutoSize = true;
            this.lblBoxHeader.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblBoxHeader.ForeColor = System.Drawing.Color.White;
            this.lblBoxHeader.Location = new System.Drawing.Point(8, 8);
            this.lblBoxHeader.Name = "lblBoxHeader";
            this.lblBoxHeader.Size = new System.Drawing.Size(182, 13);
            this.lblBoxHeader.TabIndex = 0;
            this.lblBoxHeader.Text = "Required Materials (Inventory)";
            // 
            // lblCatalystTitle
            // 
            this.lblCatalystTitle.AutoEllipsis = true;
            this.lblCatalystTitle.ForeColor = System.Drawing.Color.White;
            this.lblCatalystTitle.Location = new System.Drawing.Point(8, 28);
            this.lblCatalystTitle.Name = "lblCatalystTitle";
            this.lblCatalystTitle.Size = new System.Drawing.Size(200, 16);
            this.lblCatalystTitle.TabIndex = 1;
            this.lblCatalystTitle.Text = "Dragon Runestone [7132]:";
            // 
            // lblCatalystStatus
            // 
            this.lblCatalystStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(90)))), ((int)(((byte)(90)))));
            this.lblCatalystStatus.Location = new System.Drawing.Point(215, 28);
            this.lblCatalystStatus.Name = "lblCatalystStatus";
            this.lblCatalystStatus.Size = new System.Drawing.Size(95, 16);
            this.lblCatalystStatus.TabIndex = 2;
            this.lblCatalystStatus.Text = "0 [MISSING]";
            this.lblCatalystStatus.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // lblReagent1Title
            // 
            this.lblReagent1Title.AutoEllipsis = true;
            this.lblReagent1Title.ForeColor = System.Drawing.Color.White;
            this.lblReagent1Title.Location = new System.Drawing.Point(8, 50);
            this.lblReagent1Title.Name = "lblReagent1Title";
            this.lblReagent1Title.Size = new System.Drawing.Size(200, 16);
            this.lblReagent1Title.TabIndex = 3;
            this.lblReagent1Title.Text = "Reagent 1:";
            // 
            // lblReagent1Status
            // 
            this.lblReagent1Status.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(90)))), ((int)(((byte)(90)))));
            this.lblReagent1Status.Location = new System.Drawing.Point(215, 50);
            this.lblReagent1Status.Name = "lblReagent1Status";
            this.lblReagent1Status.Size = new System.Drawing.Size(95, 16);
            this.lblReagent1Status.TabIndex = 4;
            this.lblReagent1Status.Text = "0 [MISSING]";
            this.lblReagent1Status.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // lblReagent2Title
            // 
            this.lblReagent2Title.AutoEllipsis = true;
            this.lblReagent2Title.ForeColor = System.Drawing.Color.White;
            this.lblReagent2Title.Location = new System.Drawing.Point(8, 72);
            this.lblReagent2Title.Name = "lblReagent2Title";
            this.lblReagent2Title.Size = new System.Drawing.Size(200, 16);
            this.lblReagent2Title.TabIndex = 5;
            this.lblReagent2Title.Text = "Reagent 2:";
            // 
            // lblReagent2Status
            // 
            this.lblReagent2Status.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(160)))), ((int)(((byte)(160)))), ((int)(((byte)(160)))));
            this.lblReagent2Status.Location = new System.Drawing.Point(215, 72);
            this.lblReagent2Status.Name = "lblReagent2Status";
            this.lblReagent2Status.Size = new System.Drawing.Size(95, 16);
            this.lblReagent2Status.TabIndex = 6;
            this.lblReagent2Status.Text = "- [None]";
            this.lblReagent2Status.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // lblMaxBrews
            // 
            this.lblMaxBrews.ForeColor = System.Drawing.Color.White;
            this.lblMaxBrews.Location = new System.Drawing.Point(8, 94);
            this.lblMaxBrews.Name = "lblMaxBrews";
            this.lblMaxBrews.Size = new System.Drawing.Size(300, 16);
            this.lblMaxBrews.TabIndex = 7;
            this.lblMaxBrews.Text = "Current bag capacity: 0x Brew";
            // 
            // btnRefresh
            // 
            this.btnRefresh.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(46)))), ((int)(((byte)(46)))), ((int)(((byte)(56)))));
            this.btnRefresh.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(70)))), ((int)(((byte)(70)))), ((int)(((byte)(80)))));
            this.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnRefresh.ForeColor = System.Drawing.Color.White;
            this.btnRefresh.Location = new System.Drawing.Point(8, 118);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Size = new System.Drawing.Size(302, 26);
            this.btnRefresh.TabIndex = 8;
            this.btnRefresh.Text = "Refresh Inventory";
            this.btnRefresh.UseVisualStyleBackColor = false;
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // lblTarget
            // 
            this.lblTarget.AutoSize = true;
            this.lblTarget.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblTarget.Location = new System.Drawing.Point(12, 248);
            this.lblTarget.Name = "lblTarget";
            this.lblTarget.Size = new System.Drawing.Size(68, 13);
            this.lblTarget.TabIndex = 4;
            this.lblTarget.Text = "Target Brew:";
            // 
            // numTarget
            // 
            this.numTarget.Location = new System.Drawing.Point(110, 246);
            this.numTarget.Maximum = new decimal(new int[] {
            9999,
            0,
            0,
            0});
            this.numTarget.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numTarget.Name = "numTarget";
            this.numTarget.Size = new System.Drawing.Size(80, 20);
            this.numTarget.TabIndex = 5;
            this.numTarget.Value = new decimal(new int[] {
            10,
            0,
            0,
            0});
            // 
            // chkStopIfOut
            // 
            this.chkStopIfOut.AutoSize = true;
            this.chkStopIfOut.Checked = true;
            this.chkStopIfOut.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkStopIfOut.Location = new System.Drawing.Point(12, 272);
            this.chkStopIfOut.Name = "chkStopIfOut";
            this.chkStopIfOut.Size = new System.Drawing.Size(141, 17);
            this.chkStopIfOut.TabIndex = 6;
            this.chkStopIfOut.Text = "Stop if materials run out";
            // 
            // btnStartStop
            // 
            this.btnStartStop.Checked = false;
            this.btnStartStop.Location = new System.Drawing.Point(12, 298);
            this.btnStartStop.Name = "btnStartStop";
            this.btnStartStop.Size = new System.Drawing.Size(320, 32);
            this.btnStartStop.TabIndex = 7;
            this.btnStartStop.Text = "START BREWING";
            this.btnStartStop.Click += new System.EventHandler(this.btnStartStop_Click);
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(12, 338);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(320, 16);
            this.progressBar.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressBar.TabIndex = 8;
            // 
            // lblStatus
            // 
            this.lblStatus.AutoEllipsis = true;
            this.lblStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblStatus.Location = new System.Drawing.Point(12, 360);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(320, 18);
            this.lblStatus.TabIndex = 9;
            this.lblStatus.Text = "Status: Idle";
            // 
            // AlchemistForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.ClientSize = new System.Drawing.Size(344, 388);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.btnStartStop);
            this.Controls.Add(this.chkStopIfOut);
            this.Controls.Add(this.numTarget);
            this.Controls.Add(this.lblTarget);
            this.Controls.Add(this.pnlMaterials);
            this.Controls.Add(this.cmbPotions);
            this.Controls.Add(this.txtSearch);
            this.Controls.Add(this.lblSearch);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "AlchemistForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "CODEX Alchemist";
            this.TopMost = true;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.AlchemistForm_FormClosing);
            this.Load += new System.EventHandler(this.AlchemistForm_Load);
            this.pnlMaterials.ResumeLayout(false);
            this.pnlMaterials.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numTarget)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DarkUI.Controls.DarkLabel lblSearch;
        private DarkUI.Controls.DarkTextBox txtSearch;
        private DarkUI.Controls.DarkComboBox cmbPotions;
        private System.Windows.Forms.Panel pnlMaterials;
        private System.Windows.Forms.Label lblBoxHeader;
        private DarkUI.Controls.DarkLabel lblCatalystTitle;
        private DarkUI.Controls.DarkLabel lblCatalystStatus;
        private DarkUI.Controls.DarkLabel lblReagent1Title;
        private DarkUI.Controls.DarkLabel lblReagent1Status;
        private DarkUI.Controls.DarkLabel lblReagent2Title;
        private DarkUI.Controls.DarkLabel lblReagent2Status;
        private DarkUI.Controls.DarkLabel lblMaxBrews;
        private System.Windows.Forms.Button btnRefresh;
        private DarkUI.Controls.DarkLabel lblTarget;
        private DarkUI.Controls.DarkNumericUpDown numTarget;
        private DarkUI.Controls.DarkCheckBox chkStopIfOut;
        private DarkUI.Controls.DarkButton btnStartStop;
        private System.Windows.Forms.ProgressBar progressBar;
        private DarkUI.Controls.DarkLabel lblStatus;
    }
}

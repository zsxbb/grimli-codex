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
            this.lblPotionTitle = new DarkUI.Controls.DarkLabel();
            this.lblPotionStatus = new DarkUI.Controls.DarkLabel();
            this.pnlMaterials = new System.Windows.Forms.Panel();
            this.lblBoxHeader = new System.Windows.Forms.Label();
            this.lblCatalystTitle = new DarkUI.Controls.DarkLabel();
            this.lblCatalystStatus = new DarkUI.Controls.DarkLabel();
            this.lblReagent1Title = new DarkUI.Controls.DarkLabel();
            this.lblReagent1Status = new DarkUI.Controls.DarkLabel();
            this.lblReagent2Title = new DarkUI.Controls.DarkLabel();
            this.lblReagent2Status = new DarkUI.Controls.DarkLabel();
            this.btnRefresh = new System.Windows.Forms.Button();
            this.lblChoose = new DarkUI.Controls.DarkLabel();
            this.rbTargetBrew = new DarkUI.Controls.DarkRadioButton();
            this.rbTargetPotion = new DarkUI.Controls.DarkRadioButton();
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
            this.cmbPotions.Location = new System.Drawing.Point(12, 52);
            this.cmbPotions.Name = "cmbPotions";
            this.cmbPotions.Size = new System.Drawing.Size(320, 21);
            this.cmbPotions.TabIndex = 2;
            this.cmbPotions.SelectedIndexChanged += new System.EventHandler(this.cmbPotions_SelectedIndexChanged);
            // 
            // lblPotionTitle
            // 
            this.lblPotionTitle.AutoEllipsis = true;
            this.lblPotionTitle.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblPotionTitle.Location = new System.Drawing.Point(12, 78);
            this.lblPotionTitle.Name = "lblPotionTitle";
            this.lblPotionTitle.Size = new System.Drawing.Size(200, 16);
            this.lblPotionTitle.TabIndex = 3;
            this.lblPotionTitle.Text = "Potion in Bag:";
            // 
            // lblPotionStatus
            // 
            this.lblPotionStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(160)))), ((int)(((byte)(160)))), ((int)(((byte)(160)))));
            this.lblPotionStatus.Location = new System.Drawing.Point(215, 78);
            this.lblPotionStatus.Name = "lblPotionStatus";
            this.lblPotionStatus.Size = new System.Drawing.Size(117, 16);
            this.lblPotionStatus.TabIndex = 4;
            this.lblPotionStatus.Text = "0 [None]";
            this.lblPotionStatus.TextAlign = System.Drawing.ContentAlignment.TopRight;
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
            this.pnlMaterials.Controls.Add(this.btnRefresh);
            this.pnlMaterials.Location = new System.Drawing.Point(12, 98);
            this.pnlMaterials.Name = "pnlMaterials";
            this.pnlMaterials.Size = new System.Drawing.Size(320, 126);
            this.pnlMaterials.TabIndex = 5;
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
            this.lblReagent1Title.Location = new System.Drawing.Point(8, 48);
            this.lblReagent1Title.Name = "lblReagent1Title";
            this.lblReagent1Title.Size = new System.Drawing.Size(200, 16);
            this.lblReagent1Title.TabIndex = 3;
            this.lblReagent1Title.Text = "Reagent 1:";
            // 
            // lblReagent1Status
            // 
            this.lblReagent1Status.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(90)))), ((int)(((byte)(90)))));
            this.lblReagent1Status.Location = new System.Drawing.Point(215, 48);
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
            this.lblReagent2Title.Location = new System.Drawing.Point(8, 68);
            this.lblReagent2Title.Name = "lblReagent2Title";
            this.lblReagent2Title.Size = new System.Drawing.Size(200, 16);
            this.lblReagent2Title.TabIndex = 5;
            this.lblReagent2Title.Text = "Reagent 2:";
            // 
            // lblReagent2Status
            // 
            this.lblReagent2Status.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(160)))), ((int)(((byte)(160)))), ((int)(((byte)(160)))));
            this.lblReagent2Status.Location = new System.Drawing.Point(215, 68);
            this.lblReagent2Status.Name = "lblReagent2Status";
            this.lblReagent2Status.Size = new System.Drawing.Size(95, 16);
            this.lblReagent2Status.TabIndex = 6;
            this.lblReagent2Status.Text = "- [None]";
            this.lblReagent2Status.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // btnRefresh
            // 
            this.btnRefresh.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(46)))), ((int)(((byte)(46)))), ((int)(((byte)(56)))));
            this.btnRefresh.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(70)))), ((int)(((byte)(70)))), ((int)(((byte)(80)))));
            this.btnRefresh.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnRefresh.ForeColor = System.Drawing.Color.White;
            this.btnRefresh.Location = new System.Drawing.Point(8, 92);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Size = new System.Drawing.Size(302, 24);
            this.btnRefresh.TabIndex = 7;
            this.btnRefresh.Text = "Refresh Inventory";
            this.btnRefresh.UseVisualStyleBackColor = false;
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // lblChoose
            // 
            this.lblChoose.AutoSize = true;
            this.lblChoose.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblChoose.Location = new System.Drawing.Point(12, 238);
            this.lblChoose.Name = "lblChoose";
            this.lblChoose.Size = new System.Drawing.Size(46, 13);
            this.lblChoose.TabIndex = 6;
            this.lblChoose.Text = "Choose:";
            // 
            // rbTargetBrew
            // 
            this.rbTargetBrew.AutoSize = true;
            this.rbTargetBrew.Checked = true;
            this.rbTargetBrew.Location = new System.Drawing.Point(68, 236);
            this.rbTargetBrew.Name = "rbTargetBrew";
            this.rbTargetBrew.Size = new System.Drawing.Size(84, 17);
            this.rbTargetBrew.TabIndex = 7;
            this.rbTargetBrew.TabStop = true;
            this.rbTargetBrew.Text = "Target Brew";
            this.rbTargetBrew.CheckedChanged += new System.EventHandler(this.rbTarget_CheckedChanged);
            // 
            // rbTargetPotion
            // 
            this.rbTargetPotion.AutoSize = true;
            this.rbTargetPotion.Location = new System.Drawing.Point(170, 236);
            this.rbTargetPotion.Name = "rbTargetPotion";
            this.rbTargetPotion.Size = new System.Drawing.Size(95, 17);
            this.rbTargetPotion.TabIndex = 8;
            this.rbTargetPotion.Text = "Target Potions";
            this.rbTargetPotion.CheckedChanged += new System.EventHandler(this.rbTarget_CheckedChanged);
            // 
            // lblTarget
            // 
            this.lblTarget.AutoSize = true;
            this.lblTarget.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblTarget.Location = new System.Drawing.Point(12, 262);
            this.lblTarget.Name = "lblTarget";
            this.lblTarget.Size = new System.Drawing.Size(46, 13);
            this.lblTarget.TabIndex = 9;
            this.lblTarget.Text = "Amount:";
            // 
            // numTarget
            // 
            this.numTarget.Location = new System.Drawing.Point(68, 260);
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
            this.numTarget.TabIndex = 10;
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
            this.chkStopIfOut.Location = new System.Drawing.Point(12, 286);
            this.chkStopIfOut.Name = "chkStopIfOut";
            this.chkStopIfOut.Size = new System.Drawing.Size(141, 17);
            this.chkStopIfOut.TabIndex = 11;
            this.chkStopIfOut.Text = "Stop if materials run out";
            // 
            // btnStartStop
            // 
            this.btnStartStop.Checked = false;
            this.btnStartStop.Location = new System.Drawing.Point(12, 310);
            this.btnStartStop.Name = "btnStartStop";
            this.btnStartStop.Size = new System.Drawing.Size(320, 30);
            this.btnStartStop.TabIndex = 12;
            this.btnStartStop.Text = "START BREWING";
            this.btnStartStop.Click += new System.EventHandler(this.btnStartStop_Click);
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(12, 346);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(320, 14);
            this.progressBar.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressBar.TabIndex = 13;
            // 
            // lblStatus
            // 
            this.lblStatus.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblStatus.Location = new System.Drawing.Point(12, 366);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(320, 72);
            this.lblStatus.TabIndex = 14;
            this.lblStatus.Text = "Status: Idle";
            // 
            // AlchemistForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.ClientSize = new System.Drawing.Size(344, 446);
            this.Controls.Add(this.lblStatus);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.btnStartStop);
            this.Controls.Add(this.chkStopIfOut);
            this.Controls.Add(this.numTarget);
            this.Controls.Add(this.lblTarget);
            this.Controls.Add(this.rbTargetPotion);
            this.Controls.Add(this.rbTargetBrew);
            this.Controls.Add(this.lblChoose);
            this.Controls.Add(this.pnlMaterials);
            this.Controls.Add(this.lblPotionStatus);
            this.Controls.Add(this.lblPotionTitle);
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
        private DarkUI.Controls.DarkLabel lblPotionTitle;
        private DarkUI.Controls.DarkLabel lblPotionStatus;
        private System.Windows.Forms.Panel pnlMaterials;
        private System.Windows.Forms.Label lblBoxHeader;
        private DarkUI.Controls.DarkLabel lblCatalystTitle;
        private DarkUI.Controls.DarkLabel lblCatalystStatus;
        private DarkUI.Controls.DarkLabel lblReagent1Title;
        private DarkUI.Controls.DarkLabel lblReagent1Status;
        private DarkUI.Controls.DarkLabel lblReagent2Title;
        private DarkUI.Controls.DarkLabel lblReagent2Status;
        private System.Windows.Forms.Button btnRefresh;
        private DarkUI.Controls.DarkLabel lblChoose;
        private DarkUI.Controls.DarkRadioButton rbTargetBrew;
        private DarkUI.Controls.DarkRadioButton rbTargetPotion;
        private DarkUI.Controls.DarkLabel lblTarget;
        private DarkUI.Controls.DarkNumericUpDown numTarget;
        private DarkUI.Controls.DarkCheckBox chkStopIfOut;
        private DarkUI.Controls.DarkButton btnStartStop;
        private System.Windows.Forms.ProgressBar progressBar;
        private DarkUI.Controls.DarkLabel lblStatus;
    }
}

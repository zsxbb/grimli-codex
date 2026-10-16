using System.Windows.Forms;

namespace Grimoire.UI
{
    partial class CodexSkillForm
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
            this.chkEnableSkillMoment = new DarkUI.Controls.DarkCheckBox();
            this.lblCurrentTarget = new DarkUI.Controls.DarkLabel();
            this.lblTriggerType = new DarkUI.Controls.DarkLabel();
            this.cmbTriggerType = new DarkUI.Controls.DarkComboBox();
            this.lblSkill1 = new DarkUI.Controls.DarkLabel();
            this.cmbSkill1 = new DarkUI.Controls.DarkComboBox();
            this.lblDelay = new DarkUI.Controls.DarkLabel();
            this.txtDelay = new DarkUI.Controls.DarkTextBox();
            this.lblKeyword = new DarkUI.Controls.DarkLabel();
            this.txtKeyword = new DarkUI.Controls.DarkTextBox();
            this.lblOccurrence = new DarkUI.Controls.DarkLabel();
            this.cmbOccurrence = new DarkUI.Controls.DarkComboBox();
            this.lblHpType = new DarkUI.Controls.DarkLabel();
            this.cmbHpType = new DarkUI.Controls.DarkComboBox();
            this.lblHpValue = new DarkUI.Controls.DarkLabel();
            this.txtHpValue = new DarkUI.Controls.DarkTextBox();
            this.btnAddRule = new DarkUI.Controls.DarkButton();
            this.btnRemoveRule = new DarkUI.Controls.DarkButton();
            this.btnSaveRules = new DarkUI.Controls.DarkButton();
            this.btnLoadRules = new DarkUI.Controls.DarkButton();
            this.gbRulesList = new DarkUI.Controls.DarkGroupBox();
            this.lstRules = new System.Windows.Forms.CheckedListBox();
            this.timerUpdate = new System.Windows.Forms.Timer(this.components);

            this.gbRulesList.SuspendLayout();
            this.SuspendLayout();

            // 
            // chkEnableSkillMoment
            // 
            this.chkEnableSkillMoment.AutoSize = true;
            this.chkEnableSkillMoment.Location = new System.Drawing.Point(10, 10);
            this.chkEnableSkillMoment.Name = "chkEnableSkillMoment";
            this.chkEnableSkillMoment.Size = new System.Drawing.Size(200, 17);
            this.chkEnableSkillMoment.TabIndex = 0;
            this.chkEnableSkillMoment.Text = "Enable Skill Moment";
            this.chkEnableSkillMoment.CheckedChanged += new System.EventHandler(this.chkEnableSkillMoment_CheckedChanged);

            // 
            // lblCurrentTarget
            // 
            this.lblCurrentTarget.AutoSize = true;
            this.lblCurrentTarget.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(240)))), ((int)(((byte)(200)))), ((int)(((byte)(80)))));
            this.lblCurrentTarget.Location = new System.Drawing.Point(10, 32);
            this.lblCurrentTarget.Name = "lblCurrentTarget";
            this.lblCurrentTarget.Size = new System.Drawing.Size(200, 13);
            this.lblCurrentTarget.TabIndex = 18;
            this.lblCurrentTarget.Text = "Target: None";

            // 
            // lblTriggerType
            // 
            this.lblTriggerType.AutoSize = true;
            this.lblTriggerType.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblTriggerType.Location = new System.Drawing.Point(10, 55);
            this.lblTriggerType.Name = "lblTriggerType";
            this.lblTriggerType.Size = new System.Drawing.Size(70, 13);
            this.lblTriggerType.TabIndex = 1;
            this.lblTriggerType.Text = "Trigger Type:";

            // 
            // cmbTriggerType
            // 
            this.cmbTriggerType.FormattingEnabled = true;
            this.cmbTriggerType.Items.AddRange(new object[] { "By Message", "By HP Monster" });
            this.cmbTriggerType.Location = new System.Drawing.Point(10, 72);
            this.cmbTriggerType.Name = "cmbTriggerType";
            this.cmbTriggerType.Size = new System.Drawing.Size(200, 21);
            this.cmbTriggerType.TabIndex = 2;
            this.cmbTriggerType.SelectedIndexChanged += new System.EventHandler(this.cmbTriggerType_SelectedIndexChanged);

            // 
            // lblSkill1
            // 
            this.lblSkill1.AutoSize = true;
            this.lblSkill1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblSkill1.Location = new System.Drawing.Point(10, 100);
            this.lblSkill1.Name = "lblSkill1";
            this.lblSkill1.Size = new System.Drawing.Size(68, 13);
            this.lblSkill1.TabIndex = 3;
            this.lblSkill1.Text = "Skill Action:";

            // 
            // cmbSkill1
            // 
            this.cmbSkill1.FormattingEnabled = true;
            this.cmbSkill1.Items.AddRange(new object[] { "1", "2", "3", "4", "5" });
            this.cmbSkill1.Location = new System.Drawing.Point(10, 117);
            this.cmbSkill1.Name = "cmbSkill1";
            this.cmbSkill1.Size = new System.Drawing.Size(95, 21);
            this.cmbSkill1.TabIndex = 4;

            // 
            // lblDelay
            // 
            this.lblDelay.AutoSize = true;
            this.lblDelay.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblDelay.Location = new System.Drawing.Point(115, 100);
            this.lblDelay.Name = "lblDelay";
            this.lblDelay.Size = new System.Drawing.Size(51, 13);
            this.lblDelay.TabIndex = 20;
            this.lblDelay.Text = "Delay(s):";

            // 
            // txtDelay
            // 
            this.txtDelay.Location = new System.Drawing.Point(115, 117);
            this.txtDelay.Name = "txtDelay";
            this.txtDelay.Size = new System.Drawing.Size(95, 20);
            this.txtDelay.TabIndex = 21;

            // 
            // lblKeyword
            // 
            this.lblKeyword.AutoSize = true;
            this.lblKeyword.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblKeyword.Location = new System.Drawing.Point(10, 145);
            this.lblKeyword.Name = "lblKeyword";
            this.lblKeyword.Size = new System.Drawing.Size(51, 13);
            this.lblKeyword.TabIndex = 5;
            this.lblKeyword.Text = "Keyword:";

            // 
            // txtKeyword
            // 
            this.txtKeyword.Location = new System.Drawing.Point(10, 162);
            this.txtKeyword.Name = "txtKeyword";
            this.txtKeyword.Size = new System.Drawing.Size(200, 20);
            this.txtKeyword.TabIndex = 6;

            // 
            // lblOccurrence
            // 
            this.lblOccurrence.AutoSize = true;
            this.lblOccurrence.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblOccurrence.Location = new System.Drawing.Point(10, 190);
            this.lblOccurrence.Name = "lblOccurrence";
            this.lblOccurrence.Size = new System.Drawing.Size(40, 13);
            this.lblOccurrence.TabIndex = 7;
            this.lblOccurrence.Text = "Match:";

            // 
            // cmbOccurrence
            // 
            this.cmbOccurrence.FormattingEnabled = true;
            this.cmbOccurrence.Items.AddRange(new object[] { "All Matches", "Odd Matches (1, 3, 5...)", "Even Matches (2, 4, 6...)" });
            this.cmbOccurrence.Location = new System.Drawing.Point(10, 207);
            this.cmbOccurrence.Name = "cmbOccurrence";
            this.cmbOccurrence.Size = new System.Drawing.Size(200, 21);
            this.cmbOccurrence.TabIndex = 8;

            // 
            // lblHpType
            // 
            this.lblHpType.AutoSize = true;
            this.lblHpType.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblHpType.Location = new System.Drawing.Point(10, 145);
            this.lblHpType.Name = "lblHpType";
            this.lblHpType.Size = new System.Drawing.Size(52, 13);
            this.lblHpType.TabIndex = 9;
            this.lblHpType.Text = "HP Type:";
            this.lblHpType.Visible = false;

            // 
            // cmbHpType
            // 
            this.cmbHpType.FormattingEnabled = true;
            this.cmbHpType.Items.AddRange(new object[] { "Percentage (%)", "Actual HP (Value)" });
            this.cmbHpType.Location = new System.Drawing.Point(10, 162);
            this.cmbHpType.Name = "cmbHpType";
            this.cmbHpType.Size = new System.Drawing.Size(200, 21);
            this.cmbHpType.TabIndex = 10;
            this.cmbHpType.Visible = false;

            // 
            // lblHpValue
            // 
            this.lblHpValue.AutoSize = true;
            this.lblHpValue.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblHpValue.Location = new System.Drawing.Point(10, 190);
            this.lblHpValue.Name = "lblHpValue";
            this.lblHpValue.Size = new System.Drawing.Size(62, 13);
            this.lblHpValue.TabIndex = 11;
            this.lblHpValue.Text = "Thresholds:";
            this.lblHpValue.Visible = false;

            // 
            // txtHpValue
            // 
            this.txtHpValue.Location = new System.Drawing.Point(10, 207);
            this.txtHpValue.Name = "txtHpValue";
            this.txtHpValue.Size = new System.Drawing.Size(200, 20);
            this.txtHpValue.TabIndex = 12;
            this.txtHpValue.Visible = false;

            // 
            // btnAddRule
            // 
            this.btnAddRule.Location = new System.Drawing.Point(10, 237);
            this.btnAddRule.Name = "btnAddRule";
            this.btnAddRule.Size = new System.Drawing.Size(95, 23);
            this.btnAddRule.TabIndex = 13;
            this.btnAddRule.Text = "Add Rule";
            this.btnAddRule.Click += new System.EventHandler(this.btnAddRule_Click);

            // 
            // btnRemoveRule
            // 
            this.btnRemoveRule.Location = new System.Drawing.Point(115, 237);
            this.btnRemoveRule.Name = "btnRemoveRule";
            this.btnRemoveRule.Size = new System.Drawing.Size(95, 23);
            this.btnRemoveRule.TabIndex = 14;
            this.btnRemoveRule.Text = "Remove";
            this.btnRemoveRule.Click += new System.EventHandler(this.btnRemoveRule_Click);

            // 
            // btnSaveRules
            // 
            this.btnSaveRules.Location = new System.Drawing.Point(10, 265);
            this.btnSaveRules.Name = "btnSaveRules";
            this.btnSaveRules.Size = new System.Drawing.Size(95, 23);
            this.btnSaveRules.TabIndex = 15;
            this.btnSaveRules.Text = "Save Rules";
            this.btnSaveRules.Click += new System.EventHandler(this.btnSaveRules_Click);

            // 
            // btnLoadRules
            // 
            this.btnLoadRules.Location = new System.Drawing.Point(115, 265);
            this.btnLoadRules.Name = "btnLoadRules";
            this.btnLoadRules.Size = new System.Drawing.Size(95, 23);
            this.btnLoadRules.TabIndex = 16;
            this.btnLoadRules.Text = "Load Rules";
            this.btnLoadRules.Click += new System.EventHandler(this.btnLoadRules_Click);

            // 
            // gbRulesList
            // 
            this.gbRulesList.Controls.Add(this.lstRules);
            this.gbRulesList.Location = new System.Drawing.Point(10, 297);
            this.gbRulesList.Name = "gbRulesList";
            this.gbRulesList.Size = new System.Drawing.Size(200, 195);
            this.gbRulesList.TabIndex = 17;
            this.gbRulesList.TabStop = false;
            this.gbRulesList.Text = "Active Rules";

            // 
            // lstRules
            // 
            this.lstRules.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(36)))), ((int)(((byte)(36)))), ((int)(((byte)(46)))));
            this.lstRules.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.lstRules.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lstRules.FormattingEnabled = true;
            this.lstRules.HorizontalScrollbar = true;
            this.lstRules.CheckOnClick = true;
            this.lstRules.Location = new System.Drawing.Point(6, 18);
            this.lstRules.Name = "lstRules";
            this.lstRules.Size = new System.Drawing.Size(188, 170);
            this.lstRules.TabIndex = 0;
            this.lstRules.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.lstRules_ItemCheck);

            // 
            // timerUpdate
            // 
            this.timerUpdate.Enabled = true;
            this.timerUpdate.Interval = 200;
            this.timerUpdate.Tick += new System.EventHandler(this.timerUpdate_Tick);

            // 
            // CodexSkillForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(28)))), ((int)(((byte)(28)))), ((int)(((byte)(38)))));
            this.ClientSize = new System.Drawing.Size(220, 505);
            this.Controls.Add(this.chkEnableSkillMoment);
            this.Controls.Add(this.lblCurrentTarget);
            this.Controls.Add(this.lblTriggerType);
            this.Controls.Add(this.cmbTriggerType);
            this.Controls.Add(this.lblSkill1);
            this.Controls.Add(this.cmbSkill1);
            this.Controls.Add(this.lblDelay);
            this.Controls.Add(this.txtDelay);
            this.Controls.Add(this.lblKeyword);
            this.Controls.Add(this.txtKeyword);
            this.Controls.Add(this.lblOccurrence);
            this.Controls.Add(this.cmbOccurrence);
            this.Controls.Add(this.lblHpType);
            this.Controls.Add(this.cmbHpType);
            this.Controls.Add(this.lblHpValue);
            this.Controls.Add(this.txtHpValue);
            this.Controls.Add(this.btnAddRule);
            this.Controls.Add(this.btnRemoveRule);
            this.Controls.Add(this.btnSaveRules);
            this.Controls.Add(this.btnLoadRules);
            this.Controls.Add(this.gbRulesList);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "CodexSkillForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Skill Moment";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.CodexSkillForm_FormClosing);
            this.Load += new System.EventHandler(this.CodexSkillForm_Load);
            this.gbRulesList.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        #endregion

        private DarkUI.Controls.DarkCheckBox chkEnableSkillMoment;
        private DarkUI.Controls.DarkLabel lblCurrentTarget;
        private DarkUI.Controls.DarkLabel lblTriggerType;
        private DarkUI.Controls.DarkComboBox cmbTriggerType;
        private DarkUI.Controls.DarkLabel lblSkill1;
        private DarkUI.Controls.DarkComboBox cmbSkill1;
        private DarkUI.Controls.DarkLabel lblDelay;
        private DarkUI.Controls.DarkTextBox txtDelay;
        private DarkUI.Controls.DarkLabel lblKeyword;
        private DarkUI.Controls.DarkTextBox txtKeyword;
        private DarkUI.Controls.DarkLabel lblOccurrence;
        private DarkUI.Controls.DarkComboBox cmbOccurrence;
        private DarkUI.Controls.DarkLabel lblHpType;
        private DarkUI.Controls.DarkComboBox cmbHpType;
        private DarkUI.Controls.DarkLabel lblHpValue;
        private DarkUI.Controls.DarkTextBox txtHpValue;
        private DarkUI.Controls.DarkButton btnAddRule;
        private DarkUI.Controls.DarkButton btnRemoveRule;
        private DarkUI.Controls.DarkButton btnSaveRules;
        private DarkUI.Controls.DarkButton btnLoadRules;
        private DarkUI.Controls.DarkGroupBox gbRulesList;
        private System.Windows.Forms.CheckedListBox lstRules;
        private System.Windows.Forms.Timer timerUpdate;
    }
}

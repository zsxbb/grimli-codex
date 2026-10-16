namespace Grimoire.UI
{
    partial class QuestPinnerForm
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                StopAutoTurnIn();
                if (_autoTurnInTimer != null)
                {
                    _autoTurnInTimer.Dispose();
                    _autoTurnInTimer = null;
                }
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.lstQuests = new System.Windows.Forms.ListBox();
            this.lblQuestId = new DarkUI.Controls.DarkLabel();
            this.numQuestId = new DarkUI.Controls.DarkNumericUpDown();
            this.lblQuestName = new DarkUI.Controls.DarkLabel();
            this.tbQuestName = new DarkUI.Controls.DarkTextBox();
            this.btnAddQuest = new DarkUI.Controls.DarkButton();
            this.btnRemoveQuest = new DarkUI.Controls.DarkButton();
            this.btnLoadSelected = new DarkUI.Controls.DarkButton();
            this.btnAutoTurnIn = new DarkUI.Controls.DarkButton();
            this.btnSave = new DarkUI.Controls.DarkButton();
            this.btnUp = new DarkUI.Controls.DarkButton();
            this.btnDown = new DarkUI.Controls.DarkButton();
            this.btnAcceptSelected = new DarkUI.Controls.DarkButton();
            ((System.ComponentModel.ISupportInitialize)(this.numQuestId)).BeginInit();
            this.SuspendLayout();
            // 
            // lstQuests
            // 
            this.lstQuests.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.lstQuests.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lstQuests.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lstQuests.FormattingEnabled = true;
            this.lstQuests.Location = new System.Drawing.Point(12, 12);
            this.lstQuests.Name = "lstQuests";
            this.lstQuests.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple;
            this.lstQuests.Size = new System.Drawing.Size(214, 158);
            this.lstQuests.TabIndex = 0;
            // 
            // lblQuestId
            // 
            this.lblQuestId.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblQuestId.Location = new System.Drawing.Point(12, 183);
            this.lblQuestId.Name = "lblQuestId";
            this.lblQuestId.Size = new System.Drawing.Size(80, 20);
            this.lblQuestId.TabIndex = 1;
            this.lblQuestId.Text = "Quest ID:";
            // 
            // numQuestId
            // 
            this.numQuestId.Location = new System.Drawing.Point(92, 181);
            this.numQuestId.Maximum = new decimal(new int[] {
            1000000,
            0,
            0,
            0});
            this.numQuestId.Name = "numQuestId";
            this.numQuestId.Size = new System.Drawing.Size(180, 20);
            this.numQuestId.TabIndex = 2;
            // 
            // lblQuestName
            // 
            this.lblQuestName.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblQuestName.Location = new System.Drawing.Point(12, 209);
            this.lblQuestName.Name = "lblQuestName";
            this.lblQuestName.Size = new System.Drawing.Size(80, 20);
            this.lblQuestName.TabIndex = 3;
            this.lblQuestName.Text = "Quest Name:";
            // 
            // tbQuestName
            // 
            this.tbQuestName.Location = new System.Drawing.Point(92, 207);
            this.tbQuestName.Name = "tbQuestName";
            this.tbQuestName.Size = new System.Drawing.Size(180, 20);
            this.tbQuestName.TabIndex = 4;
            // 
            // btnAddQuest
            // 
            this.btnAddQuest.Checked = false;
            this.btnAddQuest.Location = new System.Drawing.Point(12, 240);
            this.btnAddQuest.Name = "btnAddQuest";
            this.btnAddQuest.Size = new System.Drawing.Size(125, 23);
            this.btnAddQuest.TabIndex = 5;
            this.btnAddQuest.Text = "Add Quest";
            this.btnAddQuest.Click += new System.EventHandler(this.btnAddQuest_Click);
            // 
            // btnRemoveQuest
            // 
            this.btnRemoveQuest.Checked = false;
            this.btnRemoveQuest.Location = new System.Drawing.Point(147, 240);
            this.btnRemoveQuest.Name = "btnRemoveQuest";
            this.btnRemoveQuest.Size = new System.Drawing.Size(125, 23);
            this.btnRemoveQuest.TabIndex = 6;
            this.btnRemoveQuest.Text = "Remove Quest";
            this.btnRemoveQuest.Click += new System.EventHandler(this.btnRemoveQuest_Click);
            // 
            // btnLoadSelected
            // 
            this.btnLoadSelected.Checked = false;
            this.btnLoadSelected.Location = new System.Drawing.Point(12, 269);
            this.btnLoadSelected.Name = "btnLoadSelected";
            this.btnLoadSelected.Size = new System.Drawing.Size(125, 23);
            this.btnLoadSelected.TabIndex = 7;
            this.btnLoadSelected.Text = "Load Selected";
            this.btnLoadSelected.Click += new System.EventHandler(this.btnLoadSelected_Click);
            // 
            // btnAutoTurnIn
            // 
            this.btnAutoTurnIn.Checked = false;
            this.btnAutoTurnIn.Location = new System.Drawing.Point(12, 298);
            this.btnAutoTurnIn.Name = "btnAutoTurnIn";
            this.btnAutoTurnIn.Size = new System.Drawing.Size(125, 23);
            this.btnAutoTurnIn.TabIndex = 8;
            this.btnAutoTurnIn.Text = "Auto Turn In Selected";
            this.btnAutoTurnIn.Click += new System.EventHandler(this.btnAutoTurnIn_Click);
            // 
            // btnSave
            // 
            this.btnSave.Checked = false;
            this.btnSave.Location = new System.Drawing.Point(147, 298);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(125, 23);
            this.btnSave.TabIndex = 9;
            this.btnSave.Text = "Save";
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // btnUp
            // 
            this.btnUp.Checked = false;
            this.btnUp.Location = new System.Drawing.Point(232, 12);
            this.btnUp.Name = "btnUp";
            this.btnUp.Size = new System.Drawing.Size(40, 76);
            this.btnUp.TabIndex = 10;
            this.btnUp.Text = "▲";
            this.btnUp.Click += new System.EventHandler(this.btnUp_Click);
            // 
            // btnDown
            // 
            this.btnDown.Checked = false;
            this.btnDown.Location = new System.Drawing.Point(232, 94);
            this.btnDown.Name = "btnDown";
            this.btnDown.Size = new System.Drawing.Size(40, 76);
            this.btnDown.TabIndex = 11;
            this.btnDown.Text = "▼";
            this.btnDown.Click += new System.EventHandler(this.btnDown_Click);
            // 
            // btnAcceptSelected
            // 
            this.btnAcceptSelected.Checked = false;
            this.btnAcceptSelected.Location = new System.Drawing.Point(147, 269);
            this.btnAcceptSelected.Name = "btnAcceptSelected";
            this.btnAcceptSelected.Size = new System.Drawing.Size(125, 23);
            this.btnAcceptSelected.TabIndex = 12;
            this.btnAcceptSelected.Text = "Accept Selected";
            this.btnAcceptSelected.Click += new System.EventHandler(this.btnAcceptSelected_Click);
            // 
            // QuestPinnerForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.ClientSize = new System.Drawing.Size(284, 335);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.btnAutoTurnIn);
            this.Controls.Add(this.btnLoadSelected);
            this.Controls.Add(this.btnAcceptSelected);
            this.Controls.Add(this.btnRemoveQuest);
            this.Controls.Add(this.btnAddQuest);
            this.Controls.Add(this.btnUp);
            this.Controls.Add(this.btnDown);
            this.Controls.Add(this.tbQuestName);
            this.Controls.Add(this.lblQuestName);
            this.Controls.Add(this.numQuestId);
            this.Controls.Add(this.lblQuestId);
            this.Controls.Add(this.lstQuests);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "QuestPinnerForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Quest Pinner";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.QuestPinnerForm_FormClosing);
            this.Load += new System.EventHandler(this.QuestPinnerForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.numQuestId)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        private System.Windows.Forms.ListBox lstQuests;
        private DarkUI.Controls.DarkLabel lblQuestId;
        private DarkUI.Controls.DarkNumericUpDown numQuestId;
        private DarkUI.Controls.DarkLabel lblQuestName;
        private DarkUI.Controls.DarkTextBox tbQuestName;
        private DarkUI.Controls.DarkButton btnAddQuest;
        private DarkUI.Controls.DarkButton btnRemoveQuest;
        private DarkUI.Controls.DarkButton btnLoadSelected;
        private DarkUI.Controls.DarkButton btnAutoTurnIn;
        private DarkUI.Controls.DarkButton btnSave;
        private DarkUI.Controls.DarkButton btnUp;
        private DarkUI.Controls.DarkButton btnDown;
        private DarkUI.Controls.DarkButton btnAcceptSelected;
    }
}

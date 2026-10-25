using DarkUI.Controls;
using DarkUI.Forms;
using System.Drawing;
using System.Windows.Forms;

namespace Grimoire.UI
{
    partial class UISkinForm
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
            this.colorDialog1 = new System.Windows.Forms.ColorDialog();
            this.lblHeader = new DarkUI.Controls.DarkLabel();
            this.lblPreset = new DarkUI.Controls.DarkLabel();
            this.cbPresets = new DarkUI.Controls.DarkComboBox();
            this.pnlColors = new System.Windows.Forms.Panel();
            this.lblBase = new DarkUI.Controls.DarkLabel();
            this.pnlBase = new System.Windows.Forms.Panel();
            this.lblBaseHex = new DarkUI.Controls.DarkLabel();
            this.btnPickBase = new DarkUI.Controls.DarkButton();
            this.lblNormal = new DarkUI.Controls.DarkLabel();
            this.pnlNormal = new System.Windows.Forms.Panel();
            this.lblNormalHex = new DarkUI.Controls.DarkLabel();
            this.btnPickNormal = new DarkUI.Controls.DarkButton();
            this.lblHover = new DarkUI.Controls.DarkLabel();
            this.pnlHover = new System.Windows.Forms.Panel();
            this.lblHoverHex = new DarkUI.Controls.DarkLabel();
            this.btnPickHover = new DarkUI.Controls.DarkButton();
            this.lblPressed = new DarkUI.Controls.DarkLabel();
            this.pnlPressed = new System.Windows.Forms.Panel();
            this.lblPressedHex = new DarkUI.Controls.DarkLabel();
            this.btnPickPressed = new DarkUI.Controls.DarkButton();
            this.lblBorder = new DarkUI.Controls.DarkLabel();
            this.pnlBorder = new System.Windows.Forms.Panel();
            this.lblBorderHex = new DarkUI.Controls.DarkLabel();
            this.btnPickBorder = new DarkUI.Controls.DarkButton();
            this.lblText = new DarkUI.Controls.DarkLabel();
            this.pnlText = new System.Windows.Forms.Panel();
            this.lblTextHex = new DarkUI.Controls.DarkLabel();
            this.btnPickText = new DarkUI.Controls.DarkButton();
            this.grpPreview = new DarkUI.Controls.DarkGroupBox();
            this.btnPreview1 = new DarkUI.Controls.DarkButton();
            this.btnPreview2 = new DarkUI.Controls.DarkButton();
            this.btnApply = new DarkUI.Controls.DarkButton();
            this.btnSave = new DarkUI.Controls.DarkButton();
            this.btnReset = new DarkUI.Controls.DarkButton();
            this.btnClose = new DarkUI.Controls.DarkButton();
            this.pnlColors.SuspendLayout();
            this.grpPreview.SuspendLayout();
            this.SuspendLayout();
            // 
            // colorDialog1
            // 
            this.colorDialog1.AnyColor = true;
            this.colorDialog1.FullOpen = true;
            // 
            // lblHeader
            // 
            this.lblHeader.AutoSize = true;
            this.lblHeader.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblHeader.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblHeader.Location = new System.Drawing.Point(18, 14);
            this.lblHeader.Name = "lblHeader";
            this.lblHeader.Size = new System.Drawing.Size(206, 17);
            this.lblHeader.TabIndex = 0;
            this.lblHeader.Text = "UI Skin & Button Color Settings";
            // 
            // lblPreset
            // 
            this.lblPreset.AutoSize = true;
            this.lblPreset.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblPreset.Location = new System.Drawing.Point(18, 45);
            this.lblPreset.Name = "lblPreset";
            this.lblPreset.Size = new System.Drawing.Size(78, 13);
            this.lblPreset.TabIndex = 1;
            this.lblPreset.Text = "Theme Preset:";
            // 
            // cbPresets
            // 
            this.cbPresets.FormattingEnabled = true;
            this.cbPresets.Location = new System.Drawing.Point(102, 42);
            this.cbPresets.Name = "cbPresets";
            this.cbPresets.Size = new System.Drawing.Size(298, 21);
            this.cbPresets.TabIndex = 2;
            this.cbPresets.SelectedIndexChanged += new System.EventHandler(this.cbPresets_SelectedIndexChanged);
            // 
            // pnlColors
            // 
            this.pnlColors.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlColors.Controls.Add(this.lblBase);
            this.pnlColors.Controls.Add(this.pnlBase);
            this.pnlColors.Controls.Add(this.lblBaseHex);
            this.pnlColors.Controls.Add(this.btnPickBase);
            this.pnlColors.Controls.Add(this.lblNormal);
            this.pnlColors.Controls.Add(this.pnlNormal);
            this.pnlColors.Controls.Add(this.lblNormalHex);
            this.pnlColors.Controls.Add(this.btnPickNormal);
            this.pnlColors.Controls.Add(this.lblHover);
            this.pnlColors.Controls.Add(this.pnlHover);
            this.pnlColors.Controls.Add(this.lblHoverHex);
            this.pnlColors.Controls.Add(this.btnPickHover);
            this.pnlColors.Controls.Add(this.lblPressed);
            this.pnlColors.Controls.Add(this.pnlPressed);
            this.pnlColors.Controls.Add(this.lblPressedHex);
            this.pnlColors.Controls.Add(this.btnPickPressed);
            this.pnlColors.Controls.Add(this.lblBorder);
            this.pnlColors.Controls.Add(this.pnlBorder);
            this.pnlColors.Controls.Add(this.lblBorderHex);
            this.pnlColors.Controls.Add(this.btnPickBorder);
            this.pnlColors.Controls.Add(this.lblText);
            this.pnlColors.Controls.Add(this.pnlText);
            this.pnlColors.Controls.Add(this.lblTextHex);
            this.pnlColors.Controls.Add(this.btnPickText);
            this.pnlColors.Location = new System.Drawing.Point(21, 74);
            this.pnlColors.Name = "pnlColors";
            this.pnlColors.Size = new System.Drawing.Size(379, 204);
            this.pnlColors.TabIndex = 3;
            // 
            // lblBase
            // 
            this.lblBase.AutoSize = true;
            this.lblBase.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblBase.Location = new System.Drawing.Point(12, 12);
            this.lblBase.Name = "lblBase";
            this.lblBase.Size = new System.Drawing.Size(95, 13);
            this.lblBase.TabIndex = 0;
            this.lblBase.Text = "Base Background:";
            // 
            // pnlBase
            // 
            this.pnlBase.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlBase.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pnlBase.Location = new System.Drawing.Point(155, 8);
            this.pnlBase.Name = "pnlBase";
            this.pnlBase.Size = new System.Drawing.Size(42, 22);
            this.pnlBase.TabIndex = 1;
            this.pnlBase.Click += new System.EventHandler(this.btnPickBase_Click);
            // 
            // lblBaseHex
            // 
            this.lblBaseHex.AutoSize = true;
            this.lblBaseHex.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblBaseHex.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.lblBaseHex.Location = new System.Drawing.Point(208, 12);
            this.lblBaseHex.Name = "lblBaseHex";
            this.lblBaseHex.Size = new System.Drawing.Size(56, 14);
            this.lblBaseHex.TabIndex = 2;
            this.lblBaseHex.Text = "#24242E";
            // 
            // btnPickBase
            // 
            this.btnPickBase.Checked = false;
            this.btnPickBase.Location = new System.Drawing.Point(292, 8);
            this.btnPickBase.Name = "btnPickBase";
            this.btnPickBase.Size = new System.Drawing.Size(72, 22);
            this.btnPickBase.TabIndex = 3;
            this.btnPickBase.Text = "Pick...";
            this.btnPickBase.Click += new System.EventHandler(this.btnPickBase_Click);
            // 
            // lblNormal
            // 
            this.lblNormal.AutoSize = true;
            this.lblNormal.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblNormal.Location = new System.Drawing.Point(12, 44);
            this.lblNormal.Name = "lblNormal";
            this.lblNormal.Size = new System.Drawing.Size(107, 13);
            this.lblNormal.TabIndex = 4;
            this.lblNormal.Text = "Normal Background:";
            // 
            // pnlNormal
            // 
            this.pnlNormal.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlNormal.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pnlNormal.Location = new System.Drawing.Point(155, 40);
            this.pnlNormal.Name = "pnlNormal";
            this.pnlNormal.Size = new System.Drawing.Size(42, 22);
            this.pnlNormal.TabIndex = 5;
            this.pnlNormal.Click += new System.EventHandler(this.btnPickNormal_Click);
            // 
            // lblNormalHex
            // 
            this.lblNormalHex.AutoSize = true;
            this.lblNormalHex.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblNormalHex.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.lblNormalHex.Location = new System.Drawing.Point(208, 44);
            this.lblNormalHex.Name = "lblNormalHex";
            this.lblNormalHex.Size = new System.Drawing.Size(56, 14);
            this.lblNormalHex.TabIndex = 6;
            this.lblNormalHex.Text = "#2E2E38";
            // 
            // btnPickNormal
            // 
            this.btnPickNormal.Checked = false;
            this.btnPickNormal.Location = new System.Drawing.Point(292, 40);
            this.btnPickNormal.Name = "btnPickNormal";
            this.btnPickNormal.Size = new System.Drawing.Size(72, 22);
            this.btnPickNormal.TabIndex = 7;
            this.btnPickNormal.Text = "Pick...";
            this.btnPickNormal.Click += new System.EventHandler(this.btnPickNormal_Click);
            // 
            // lblHover
            // 
            this.lblHover.AutoSize = true;
            this.lblHover.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblHover.Location = new System.Drawing.Point(12, 76);
            this.lblHover.Name = "lblHover";
            this.lblHover.Size = new System.Drawing.Size(101, 13);
            this.lblHover.TabIndex = 8;
            this.lblHover.Text = "Hover Background:";
            // 
            // pnlHover
            // 
            this.pnlHover.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlHover.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pnlHover.Location = new System.Drawing.Point(155, 72);
            this.pnlHover.Name = "pnlHover";
            this.pnlHover.Size = new System.Drawing.Size(42, 22);
            this.pnlHover.TabIndex = 9;
            this.pnlHover.Click += new System.EventHandler(this.btnPickHover_Click);
            // 
            // lblHoverHex
            // 
            this.lblHoverHex.AutoSize = true;
            this.lblHoverHex.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblHoverHex.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.lblHoverHex.Location = new System.Drawing.Point(208, 76);
            this.lblHoverHex.Name = "lblHoverHex";
            this.lblHoverHex.Size = new System.Drawing.Size(56, 14);
            this.lblHoverHex.TabIndex = 10;
            this.lblHoverHex.Text = "#5A5A64";
            // 
            // btnPickHover
            // 
            this.btnPickHover.Checked = false;
            this.btnPickHover.Location = new System.Drawing.Point(292, 72);
            this.btnPickHover.Name = "btnPickHover";
            this.btnPickHover.Size = new System.Drawing.Size(72, 22);
            this.btnPickHover.TabIndex = 11;
            this.btnPickHover.Text = "Pick...";
            this.btnPickHover.Click += new System.EventHandler(this.btnPickHover_Click);
            // 
            // lblPressed
            // 
            this.lblPressed.AutoSize = true;
            this.lblPressed.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblPressed.Location = new System.Drawing.Point(12, 108);
            this.lblPressed.Name = "lblPressed";
            this.lblPressed.Size = new System.Drawing.Size(109, 13);
            this.lblPressed.TabIndex = 12;
            this.lblPressed.Text = "Pressed Background:";
            // 
            // pnlPressed
            // 
            this.pnlPressed.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlPressed.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pnlPressed.Location = new System.Drawing.Point(155, 104);
            this.pnlPressed.Name = "pnlPressed";
            this.pnlPressed.Size = new System.Drawing.Size(42, 22);
            this.pnlPressed.TabIndex = 13;
            this.pnlPressed.Click += new System.EventHandler(this.btnPickPressed_Click);
            // 
            // lblPressedHex
            // 
            this.lblPressedHex.AutoSize = true;
            this.lblPressedHex.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPressedHex.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.lblPressedHex.Location = new System.Drawing.Point(208, 108);
            this.lblPressedHex.Name = "lblPressedHex";
            this.lblPressedHex.Size = new System.Drawing.Size(56, 14);
            this.lblPressedHex.TabIndex = 14;
            this.lblPressedHex.Text = "#2B2B35";
            // 
            // btnPickPressed
            // 
            this.btnPickPressed.Checked = false;
            this.btnPickPressed.Location = new System.Drawing.Point(292, 104);
            this.btnPickPressed.Name = "btnPickPressed";
            this.btnPickPressed.Size = new System.Drawing.Size(72, 22);
            this.btnPickPressed.TabIndex = 15;
            this.btnPickPressed.Text = "Pick...";
            this.btnPickPressed.Click += new System.EventHandler(this.btnPickPressed_Click);
            // 
            // lblBorder
            // 
            this.lblBorder.AutoSize = true;
            this.lblBorder.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblBorder.Location = new System.Drawing.Point(12, 140);
            this.lblBorder.Name = "lblBorder";
            this.lblBorder.Size = new System.Drawing.Size(75, 13);
            this.lblBorder.TabIndex = 16;
            this.lblBorder.Text = "Border Color:";
            // 
            // pnlBorder
            // 
            this.pnlBorder.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlBorder.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pnlBorder.Location = new System.Drawing.Point(155, 136);
            this.pnlBorder.Name = "pnlBorder";
            this.pnlBorder.Size = new System.Drawing.Size(42, 22);
            this.pnlBorder.TabIndex = 17;
            this.pnlBorder.Click += new System.EventHandler(this.btnPickBorder_Click);
            // 
            // lblBorderHex
            // 
            this.lblBorderHex.AutoSize = true;
            this.lblBorderHex.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblBorderHex.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.lblBorderHex.Location = new System.Drawing.Point(208, 140);
            this.lblBorderHex.Name = "lblBorderHex";
            this.lblBorderHex.Size = new System.Drawing.Size(56, 14);
            this.lblBorderHex.TabIndex = 18;
            this.lblBorderHex.Text = "#42424C";
            // 
            // btnPickBorder
            // 
            this.btnPickBorder.Checked = false;
            this.btnPickBorder.Location = new System.Drawing.Point(292, 136);
            this.btnPickBorder.Name = "btnPickBorder";
            this.btnPickBorder.Size = new System.Drawing.Size(72, 22);
            this.btnPickBorder.TabIndex = 19;
            this.btnPickBorder.Text = "Pick...";
            this.btnPickBorder.Click += new System.EventHandler(this.btnPickBorder_Click);
            // 
            // lblText
            // 
            this.lblText.AutoSize = true;
            this.lblText.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblText.Location = new System.Drawing.Point(12, 172);
            this.lblText.Name = "lblText";
            this.lblText.Size = new System.Drawing.Size(63, 13);
            this.lblText.TabIndex = 20;
            this.lblText.Text = "Text Color:";
            // 
            // pnlText
            // 
            this.pnlText.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlText.Cursor = System.Windows.Forms.Cursors.Hand;
            this.pnlText.Location = new System.Drawing.Point(155, 168);
            this.pnlText.Name = "pnlText";
            this.pnlText.Size = new System.Drawing.Size(42, 22);
            this.pnlText.TabIndex = 21;
            this.pnlText.Click += new System.EventHandler(this.btnPickText_Click);
            // 
            // lblTextHex
            // 
            this.lblTextHex.AutoSize = true;
            this.lblTextHex.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTextHex.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.lblTextHex.Location = new System.Drawing.Point(208, 172);
            this.lblTextHex.Name = "lblTextHex";
            this.lblTextHex.Size = new System.Drawing.Size(56, 14);
            this.lblTextHex.TabIndex = 22;
            this.lblTextHex.Text = "#DCDCDC";
            // 
            // btnPickText
            // 
            this.btnPickText.Checked = false;
            this.btnPickText.Location = new System.Drawing.Point(292, 168);
            this.btnPickText.Name = "btnPickText";
            this.btnPickText.Size = new System.Drawing.Size(72, 22);
            this.btnPickText.TabIndex = 23;
            this.btnPickText.Text = "Pick...";
            this.btnPickText.Click += new System.EventHandler(this.btnPickText_Click);
            // 
            // grpPreview
            // 
            this.grpPreview.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(51)))), ((int)(((byte)(51)))), ((int)(((byte)(51)))));
            this.grpPreview.Controls.Add(this.btnPreview1);
            this.grpPreview.Controls.Add(this.btnPreview2);
            this.grpPreview.Location = new System.Drawing.Point(21, 290);
            this.grpPreview.Name = "grpPreview";
            this.grpPreview.Size = new System.Drawing.Size(379, 78);
            this.grpPreview.TabIndex = 4;
            this.grpPreview.TabStop = false;
            this.grpPreview.Text = "Live Button Preview";
            // 
            // btnPreview1
            // 
            this.btnPreview1.Checked = false;
            this.btnPreview1.Location = new System.Drawing.Point(18, 28);
            this.btnPreview1.Name = "btnPreview1";
            this.btnPreview1.Size = new System.Drawing.Size(190, 32);
            this.btnPreview1.TabIndex = 0;
            this.btnPreview1.Text = "Hover Me / Click Me";
            // 
            // btnPreview2
            // 
            this.btnPreview2.Checked = true;
            this.btnPreview2.Location = new System.Drawing.Point(222, 28);
            this.btnPreview2.Name = "btnPreview2";
            this.btnPreview2.Size = new System.Drawing.Size(142, 32);
            this.btnPreview2.TabIndex = 1;
            this.btnPreview2.Text = "Checked State";
            // 
            // btnApply
            // 
            this.btnApply.Checked = false;
            this.btnApply.Location = new System.Drawing.Point(21, 382);
            this.btnApply.Name = "btnApply";
            this.btnApply.Size = new System.Drawing.Size(86, 26);
            this.btnApply.TabIndex = 5;
            this.btnApply.Text = "Apply";
            this.btnApply.Click += new System.EventHandler(this.btnApply_Click);
            // 
            // btnSave
            // 
            this.btnSave.Checked = false;
            this.btnSave.Location = new System.Drawing.Point(118, 382);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(86, 26);
            this.btnSave.TabIndex = 6;
            this.btnSave.Text = "Save";
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // btnReset
            // 
            this.btnReset.Checked = false;
            this.btnReset.Location = new System.Drawing.Point(215, 382);
            this.btnReset.Name = "btnReset";
            this.btnReset.Size = new System.Drawing.Size(86, 26);
            this.btnReset.TabIndex = 7;
            this.btnReset.Text = "Reset Default";
            this.btnReset.Click += new System.EventHandler(this.btnReset_Click);
            // 
            // btnClose
            // 
            this.btnClose.Checked = false;
            this.btnClose.Location = new System.Drawing.Point(314, 382);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(86, 26);
            this.btnClose.TabIndex = 8;
            this.btnClose.Text = "Close";
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // UISkinForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(422, 424);
            this.Controls.Add(this.lblHeader);
            this.Controls.Add(this.lblPreset);
            this.Controls.Add(this.cbPresets);
            this.Controls.Add(this.pnlColors);
            this.Controls.Add(this.grpPreview);
            this.Controls.Add(this.btnApply);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.btnReset);
            this.Controls.Add(this.btnClose);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "UISkinForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "UI Skins";
            this.Load += new System.EventHandler(this.UISkinForm_Load);
            this.pnlColors.ResumeLayout(false);
            this.pnlColors.PerformLayout();
            this.grpPreview.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        private System.Windows.Forms.ColorDialog colorDialog1;
        private DarkUI.Controls.DarkLabel lblHeader;
        private DarkUI.Controls.DarkLabel lblPreset;
        private DarkUI.Controls.DarkComboBox cbPresets;
        private System.Windows.Forms.Panel pnlColors;
        private DarkUI.Controls.DarkLabel lblBase;
        private System.Windows.Forms.Panel pnlBase;
        private DarkUI.Controls.DarkLabel lblBaseHex;
        private DarkUI.Controls.DarkButton btnPickBase;
        private DarkUI.Controls.DarkLabel lblNormal;
        private System.Windows.Forms.Panel pnlNormal;
        private DarkUI.Controls.DarkLabel lblNormalHex;
        private DarkUI.Controls.DarkButton btnPickNormal;
        private DarkUI.Controls.DarkLabel lblHover;
        private System.Windows.Forms.Panel pnlHover;
        private DarkUI.Controls.DarkLabel lblHoverHex;
        private DarkUI.Controls.DarkButton btnPickHover;
        private DarkUI.Controls.DarkLabel lblPressed;
        private System.Windows.Forms.Panel pnlPressed;
        private DarkUI.Controls.DarkLabel lblPressedHex;
        private DarkUI.Controls.DarkButton btnPickPressed;
        private DarkUI.Controls.DarkLabel lblBorder;
        private System.Windows.Forms.Panel pnlBorder;
        private DarkUI.Controls.DarkLabel lblBorderHex;
        private DarkUI.Controls.DarkButton btnPickBorder;
        private DarkUI.Controls.DarkLabel lblText;
        private System.Windows.Forms.Panel pnlText;
        private DarkUI.Controls.DarkLabel lblTextHex;
        private DarkUI.Controls.DarkButton btnPickText;
        private DarkUI.Controls.DarkGroupBox grpPreview;
        private DarkUI.Controls.DarkButton btnPreview1;
        private DarkUI.Controls.DarkButton btnPreview2;
        private DarkUI.Controls.DarkButton btnApply;
        private DarkUI.Controls.DarkButton btnSave;
        private DarkUI.Controls.DarkButton btnReset;
        private DarkUI.Controls.DarkButton btnClose;
    }
}

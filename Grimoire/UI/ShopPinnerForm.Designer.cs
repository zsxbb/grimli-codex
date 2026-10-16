namespace Grimoire.UI
{
    partial class ShopPinnerForm
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
            this.lstShops = new System.Windows.Forms.ListBox();
            this.lblShopId = new DarkUI.Controls.DarkLabel();
            this.numShopId = new DarkUI.Controls.DarkNumericUpDown();
            this.lblMap = new DarkUI.Controls.DarkLabel();
            this.tbMap = new DarkUI.Controls.DarkTextBox();
            this.lblShopName = new DarkUI.Controls.DarkLabel();
            this.tbShopName = new DarkUI.Controls.DarkTextBox();
            this.btnAddShop = new DarkUI.Controls.DarkButton();
            this.btnRemoveShop = new DarkUI.Controls.DarkButton();
            this.btnLoadSelected = new DarkUI.Controls.DarkButton();
            this.btnSave = new DarkUI.Controls.DarkButton();
            this.btnUp = new DarkUI.Controls.DarkButton();
            this.btnDown = new DarkUI.Controls.DarkButton();
            ((System.ComponentModel.ISupportInitialize)(this.numShopId)).BeginInit();
            this.SuspendLayout();
            // 
            // lstShops
            // 
            this.lstShops.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.lstShops.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lstShops.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lstShops.FormattingEnabled = true;
            this.lstShops.Location = new System.Drawing.Point(12, 12);
            this.lstShops.Name = "lstShops";
            this.lstShops.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple;
            this.lstShops.Size = new System.Drawing.Size(214, 158);
            this.lstShops.TabIndex = 0;
            this.lstShops.DoubleClick += new System.EventHandler(this.lstShops_DoubleClick);
            // 
            // lblShopId
            // 
            this.lblShopId.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblShopId.Location = new System.Drawing.Point(12, 178);
            this.lblShopId.Name = "lblShopId";
            this.lblShopId.Size = new System.Drawing.Size(75, 20);
            this.lblShopId.TabIndex = 1;
            this.lblShopId.Text = "Shop ID:";
            // 
            // numShopId
            // 
            this.numShopId.Location = new System.Drawing.Point(88, 176);
            this.numShopId.Maximum = new decimal(new int[] {
            1000000,
            0,
            0,
            0});
            this.numShopId.Name = "numShopId";
            this.numShopId.Size = new System.Drawing.Size(184, 20);
            this.numShopId.TabIndex = 2;
            // 
            // lblMap
            // 
            this.lblMap.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblMap.Location = new System.Drawing.Point(12, 204);
            this.lblMap.Name = "lblMap";
            this.lblMap.Size = new System.Drawing.Size(75, 20);
            this.lblMap.TabIndex = 3;
            this.lblMap.Text = "Map Name:";
            // 
            // tbMap
            // 
            this.tbMap.Location = new System.Drawing.Point(88, 202);
            this.tbMap.Name = "tbMap";
            this.tbMap.Size = new System.Drawing.Size(184, 20);
            this.tbMap.TabIndex = 4;
            // 
            // lblShopName
            // 
            this.lblShopName.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.lblShopName.Location = new System.Drawing.Point(12, 230);
            this.lblShopName.Name = "lblShopName";
            this.lblShopName.Size = new System.Drawing.Size(75, 20);
            this.lblShopName.TabIndex = 5;
            this.lblShopName.Text = "Shop Name:";
            // 
            // tbShopName
            // 
            this.tbShopName.Location = new System.Drawing.Point(88, 228);
            this.tbShopName.Name = "tbShopName";
            this.tbShopName.Size = new System.Drawing.Size(184, 20);
            this.tbShopName.TabIndex = 6;
            // 
            // btnAddShop
            // 
            this.btnAddShop.Checked = false;
            this.btnAddShop.Location = new System.Drawing.Point(12, 258);
            this.btnAddShop.Name = "btnAddShop";
            this.btnAddShop.Size = new System.Drawing.Size(125, 23);
            this.btnAddShop.TabIndex = 7;
            this.btnAddShop.Text = "Add Shop";
            this.btnAddShop.Click += new System.EventHandler(this.btnAddShop_Click);
            // 
            // btnRemoveShop
            // 
            this.btnRemoveShop.Checked = false;
            this.btnRemoveShop.Location = new System.Drawing.Point(147, 258);
            this.btnRemoveShop.Name = "btnRemoveShop";
            this.btnRemoveShop.Size = new System.Drawing.Size(125, 23);
            this.btnRemoveShop.TabIndex = 8;
            this.btnRemoveShop.Text = "Remove Shop";
            this.btnRemoveShop.Click += new System.EventHandler(this.btnRemoveShop_Click);
            // 
            // btnLoadSelected
            // 
            this.btnLoadSelected.Checked = false;
            this.btnLoadSelected.Location = new System.Drawing.Point(12, 287);
            this.btnLoadSelected.Name = "btnLoadSelected";
            this.btnLoadSelected.Size = new System.Drawing.Size(125, 23);
            this.btnLoadSelected.TabIndex = 9;
            this.btnLoadSelected.Text = "Load Shop";
            this.btnLoadSelected.Click += new System.EventHandler(this.btnLoadSelected_Click);
            // 
            // btnSave
            // 
            this.btnSave.Checked = false;
            this.btnSave.Location = new System.Drawing.Point(147, 287);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(125, 23);
            this.btnSave.TabIndex = 10;
            this.btnSave.Text = "Save List";
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // btnUp
            // 
            this.btnUp.Checked = false;
            this.btnUp.Location = new System.Drawing.Point(232, 12);
            this.btnUp.Name = "btnUp";
            this.btnUp.Size = new System.Drawing.Size(40, 76);
            this.btnUp.TabIndex = 11;
            this.btnUp.Text = "▲";
            this.btnUp.Click += new System.EventHandler(this.btnUp_Click);
            // 
            // btnDown
            // 
            this.btnDown.Checked = false;
            this.btnDown.Location = new System.Drawing.Point(232, 94);
            this.btnDown.Name = "btnDown";
            this.btnDown.Size = new System.Drawing.Size(40, 76);
            this.btnDown.TabIndex = 12;
            this.btnDown.Text = "▼";
            this.btnDown.Click += new System.EventHandler(this.btnDown_Click);
            // 
            // ShopPinnerForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(36)))));
            this.ClientSize = new System.Drawing.Size(284, 325);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.btnLoadSelected);
            this.Controls.Add(this.btnRemoveShop);
            this.Controls.Add(this.btnAddShop);
            this.Controls.Add(this.btnUp);
            this.Controls.Add(this.btnDown);
            this.Controls.Add(this.tbShopName);
            this.Controls.Add(this.lblShopName);
            this.Controls.Add(this.tbMap);
            this.Controls.Add(this.lblMap);
            this.Controls.Add(this.numShopId);
            this.Controls.Add(this.lblShopId);
            this.Controls.Add(this.lstShops);
            this.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(220)))), ((int)(((byte)(220)))));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "ShopPinnerForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Shop Pinner";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ShopPinnerForm_FormClosing);
            this.Load += new System.EventHandler(this.ShopPinnerForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.numShopId)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        private System.Windows.Forms.ListBox lstShops;
        private DarkUI.Controls.DarkLabel lblShopId;
        private DarkUI.Controls.DarkNumericUpDown numShopId;
        private DarkUI.Controls.DarkLabel lblMap;
        private DarkUI.Controls.DarkTextBox tbMap;
        private DarkUI.Controls.DarkLabel lblShopName;
        private DarkUI.Controls.DarkTextBox tbShopName;
        private DarkUI.Controls.DarkButton btnAddShop;
        private DarkUI.Controls.DarkButton btnRemoveShop;
        private DarkUI.Controls.DarkButton btnLoadSelected;
        private DarkUI.Controls.DarkButton btnSave;
        private DarkUI.Controls.DarkButton btnUp;
        private DarkUI.Controls.DarkButton btnDown;
    }
}

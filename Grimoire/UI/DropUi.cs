using DarkUI.Forms;
using Grimoire.Botting;
using Grimoire.Game;
using Grimoire.Game.Data;
using Grimoire.Tools;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Grimoire.UI
{
    public partial class DropUi : DarkForm
    {
        public static DropUi instance { get; } = new DropUi();

        private readonly List<string> blacklisted = new List<string>();

        public DropUi()
        {
            InitializeComponent();
            InitListView();
        }

        #region ListView Related
        private void InitListView()
        {
            listView.View = View.Details;
            listView.FullRowSelect = true;
            listView.GridLines = false;
            listView.MultiSelect = true;
            listView.HideSelection = false;
            listView.OwnerDraw = true;
            listView.HeaderStyle = ColumnHeaderStyle.Clickable;

            // Column init
            listView.Columns.Clear();
            listView.Columns.Add("Name", 195);
            listView.Columns.Add("Qty", 45, HorizontalAlignment.Center);
            listView.Columns.Add("Category", 75, HorizontalAlignment.Center);
            listView.Columns.Add("AC | Member", 85, HorizontalAlignment.Center);

            // --- DRAW COLUMN HEADER ---
            listView.DrawColumnHeader += (s, e) =>
            {
                using (var brush = new SolidBrush(Color.FromArgb(35, 35, 45)))
                    e.Graphics.FillRectangle(brush, e.Bounds);

                TextRenderer.DrawText(e.Graphics, e.Header.Text, e.Font, e.Bounds, Color.White,
                    TextFormatFlags.Left | TextFormatFlags.VerticalCenter);
            };

            // --- DRAW ITEM ---
            listView.DrawItem += (s, e) =>
            {
                e.DrawDefault = false;
            };

            // --- DRAW SUB ITEM ---
            listView.DrawSubItem += (s, e) =>
            {
                bool isSelected = e.Item.Selected;

                Color backColor = isSelected ? Color.FromArgb(60, 120, 200) : Color.FromArgb(36, 36, 46);

                // Highlight AC items in golden/yellow text
                bool isAc = false;
                if (e.Item.Tag is InventoryItem tagItem)
                {
                    isAc = tagItem.IsAcItem;
                }
                else if (e.Item.SubItems.Count > 3 && e.Item.SubItems[3].Text.StartsWith("AC", StringComparison.OrdinalIgnoreCase))
                {
                    isAc = true;
                }

                Color foreColor = isSelected 
                    ? Color.White 
                    : (isAc ? Color.FromArgb(255, 215, 0) : Color.Gainsboro);

                // Background
                using (var b = new SolidBrush(backColor))
                    e.Graphics.FillRectangle(b, e.Bounds);

                // Text Alignment
                TextFormatFlags flags = TextFormatFlags.VerticalCenter | TextFormatFlags.Left;
                if (e.ColumnIndex == 1 || e.ColumnIndex == 2 || e.ColumnIndex == 3)
                {
                    flags = TextFormatFlags.VerticalCenter | TextFormatFlags.HorizontalCenter;
                }

                TextRenderer.DrawText(e.Graphics, e.SubItem.Text, e.SubItem.Font,
                    e.Bounds, foreColor, flags);

                // Grid separators
                using (var p = new Pen(Color.FromArgb(50, 50, 60)))
                {
                    e.Graphics.DrawLine(p, e.Bounds.Right - 1, e.Bounds.Top, e.Bounds.Right - 1, e.Bounds.Bottom);
                    e.Graphics.DrawLine(p, e.Bounds.Left, e.Bounds.Bottom - 1, e.Bounds.Right, e.Bounds.Bottom - 1);
                }
            };

            // Sorting
            listView.ColumnClick += (s, e) =>
            {
                if (e.Column == lastColumn)
                    descending = !descending;
                else
                    descending = false;

                lastColumn = e.Column;
                listView.ListViewItemSorter = new ListViewItemComparer(e.Column, descending);
                listView.Sort();
            };

            // Double click to take drop immediately
            listView.DoubleClick += async (s, e) =>
            {
                if (listView.SelectedItems.Count > 0)
                {
                    var selected = listView.SelectedItems[0];
                    if (selected.Tag is InventoryItem ii && ii.Id > 0)
                    {
                        await World.DropStack.GetDrop(ii.Id);
                    }
                    else
                    {
                        await World.DropStack.GetDrop(selected.Text);
                    }
                }
            };

            listView.Resize += (s, e) => AdjustColumnWidth();
            EnableDoubleBuffer(listView);
        }

        private int lastColumn = -1;
        private bool descending = false;

        private void AdjustColumnWidth()
        {
            if (listView.Columns.Count < 4)
                return;

            int fixedColumnsWidth = listView.Columns[1].Width +
                listView.Columns[2].Width +
                listView.Columns[3].Width;

            int availableWidth = listView.ClientRectangle.Width;
            int nameWidth = availableWidth - fixedColumnsWidth;
            if (nameWidth < 50) nameWidth = 50;

            listView.Columns[0].Width = nameWidth;
        }

        private void EnableDoubleBuffer(ListView lv)
        {
            lv.GetType().GetProperty("DoubleBuffered",
                System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic)
                ?.SetValue(lv, true, null);
        }

        private List<ListViewItem> GetSelected()
        {
            return listView.SelectedItems.Cast<ListViewItem>().ToList();
        }
        #endregion

        public void RemoveItem(string itemName)
        {
            if (string.IsNullOrEmpty(itemName)) return;

            if (InvokeRequired)
            {
                BeginInvoke(new Action(() => RemoveItem(itemName)));
                return;
            }

            var item = listView.Items.Cast<ListViewItem>().FirstOrDefault(i => i.Text.EqualsIgnoreCase(itemName));
            if (item == null)
                return;
            listView.Items.Remove(item);
            UpdateDropCount();
        }

        public void AddItem(InventoryItem item)
        {
            if (item == null || string.IsNullOrWhiteSpace(item.Name))
                return;

            if (InvokeRequired)
            {
                BeginInvoke(new Action(() => AddItem(item)));
                return;
            }

            if (blacklisted.Contains(item.Name))
                return;

            // check existing
            foreach (ListViewItem i in listView.Items)
            {
                if (i.Text.EqualsIgnoreCase(item.Name))
                {
                    if (int.TryParse(i.SubItems[1].Text, out int qty))
                    {
                        i.SubItems[1].Text = (qty + item.Quantity).ToString();
                    }
                    i.ListView.Invalidate(i.Bounds);
                    UpdateDropCount();
                    return;
                }
            }

            // add new
            var lvi = new ListViewItem(item.Name);
            lvi.Tag = item;
            lvi.SubItems.Add(item.Quantity.ToString());
            lvi.SubItems.Add(item.Category ?? "Item");
            string acmember = (item.IsAcItem ? "AC" : "No") + " | " + (item.IsMemberOnly ? "Yes" : "Free");
            lvi.SubItems.Add(acmember);
            listView.Items.Add(lvi);

            UpdateDropCount();
        }

        private async void btnTakeDrop_Click(object sender, EventArgs e)
        {
            var selectedItems = GetSelected();
            if (selectedItems.Count == 0)
            {
                MessageBox.Show("Please select at least one item to take.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            foreach (var item in selectedItems)
            {
                if (item.Tag is InventoryItem ii && ii.Id > 0)
                {
                    await World.DropStack.GetDrop(ii.Id);
                }
                else
                {
                    await World.DropStack.GetDrop(item.Text);
                }
                await Task.Delay(250);
            }
            UpdateDropCount();
        }

        private async void btnTakeAcDrop_Click(object sender, EventArgs e)
        {
            var toTakeIds = new HashSet<int>();
            var toTakeNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            // 1. From World.DropStack
            foreach (var drop in World.DropStack.Where(d => d.IsAcItem))
            {
                if (drop.Id > 0)
                    toTakeIds.Add(drop.Id);
            }

            // 2. From ListView items (in case of UI sync or tag info)
            foreach (ListViewItem lvi in listView.Items)
            {
                if (lvi.Tag is InventoryItem ii && ii.IsAcItem && ii.Id > 0)
                {
                    toTakeIds.Add(ii.Id);
                }
                else if (lvi.SubItems.Count > 3 && lvi.SubItems[3].Text.StartsWith("AC", StringComparison.OrdinalIgnoreCase))
                {
                    toTakeNames.Add(lvi.Text);
                }
            }

            if (toTakeIds.Count == 0 && toTakeNames.Count == 0)
            {
                return;
            }

            foreach (int id in toTakeIds)
            {
                await World.DropStack.GetDrop(id);
                await Task.Delay(250);
            }

            foreach (string name in toTakeNames)
            {
                await World.DropStack.GetDrop(name);
                await Task.Delay(250);
            }

            UpdateDropCount();
        }

        private void btnRejectBlacklist_Click(object sender, EventArgs e)
        {
            var selected = GetSelected();
            if (selected.Count == 0) return;

            foreach (var item in selected)
            {
                string name = item.Text;
                if (!blacklisted.Contains(name))
                    blacklisted.Add(name);

                var drop = World.DropStack.FirstOrDefault(d => d.Name.EqualsIgnoreCase(name));
                if (drop != null)
                {
                    if (!string.IsNullOrEmpty(drop.Name))
                        Flash.Call("RejectDrop", new string[2] { drop.Name.ToLower(), drop.Id.ToString() });
                    World.DropStack.Remove(name);
                }
                listView.Items.Remove(item);
            }

            UpdateDropCount();
        }

        private bool clearAlertMsg = false;
        private void btnClear_Click(object sender, EventArgs e)
        {
            if (!clearAlertMsg)
            {
                var result = MessageBox.Show(
                    "This action will clear all Blacklist and Current drops within the UI.\n" +
                    "Do you wish to proceed?",
                    "Caution",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Warning
                );

                if (result == DialogResult.Yes)
                {
                    clearDrop();
                    blacklisted.Clear();
                    clearAlertMsg = true;
                }
                return;
            }
            clearDrop();
        }

        public void clearDrop()
        {
            if (InvokeRequired)
            {
                BeginInvoke(new Action(clearDrop));
                return;
            }

            World.DropStack?.Clear();
            listView.Items.Clear();
            UpdateDropCount();
        }

        private bool messageAlrShown = false;
        private void RejectIngameDrop_Checkedchanged(object sender, EventArgs e)
        {
            Player.isRejectingAllDrop = cbRejectDrop.Checked;
            if (messageAlrShown)
                return;

            MessageBox.Show("This option will automatically reject non-AC drops in-game (preserves AC items). It does not override whitelist settings from bot manager.",
                "Information",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
            messageAlrShown = true;
        }

        private void UpdateDropCount()
        {
            if (InvokeRequired)
            {
                BeginInvoke(new Action(UpdateDropCount));
                return;
            }
            lblCount.Text = $"Drop count : {listView.Items.Count}";
        }

        private void DropUi_FormClosing(object sender, FormClosingEventArgs e)
        {
            e.Cancel = true;
            Hide();
        }
    }

    public class ListViewItemComparer : System.Collections.IComparer
    {
        private readonly int col;
        private readonly bool descending;

        public ListViewItemComparer(int column, bool descending = false)
        {
            col = column;
            this.descending = descending;
        }

        public int Compare(object x, object y)
        {
            var a = ((ListViewItem)x).SubItems[col].Text;
            var b = ((ListViewItem)y).SubItems[col].Text;

            int result;
            if (int.TryParse(a, out int na) && int.TryParse(b, out int nb))
                result = na.CompareTo(nb);
            else
                result = string.Compare(a, b, StringComparison.OrdinalIgnoreCase);

            return descending ? -result : result;
        }
    }
}

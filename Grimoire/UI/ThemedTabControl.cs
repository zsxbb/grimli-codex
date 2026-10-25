using System;
using System.Drawing;
using System.Windows.Forms;

namespace Grimoire.UI
{
    public class ThemedTabControl : FlatTabControl.FlatTabControl
    {
        private int _hoveredIndex = -1;

        public ThemedTabControl() : base()
        {
            this.SetStyle(ControlStyles.UserPaint | ControlStyles.AllPaintingInWmPaint | ControlStyles.OptimizedDoubleBuffer, true);
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            base.OnMouseMove(e);
            int newHover = -1;
            for (int i = 0; i < this.TabCount; i++)
            {
                if (this.GetTabRect(i).Contains(e.Location))
                {
                    newHover = i;
                    break;
                }
            }
            if (newHover != _hoveredIndex)
            {
                _hoveredIndex = newHover;
                this.Invalidate(true);
            }
        }

        protected override void OnMouseLeave(EventArgs e)
        {
            base.OnMouseLeave(e);
            if (_hoveredIndex != -1)
            {
                _hoveredIndex = -1;
                this.Invalidate(true);
            }
        }

        protected override void OnSelectedIndexChanged(EventArgs e)
        {
            base.OnSelectedIndexChanged(e);
            this.Invalidate(true);
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            if (!this.Visible) return;

            Graphics g = e.Graphics;
            Rectangle clientRectangle = this.ClientRectangle;
            Rectangle displayRectangle = this.DisplayRectangle;

            Color baseColor = UISkinManager.BaseColor;
            Color borderColor = UISkinManager.BorderColor;
            Color textColor = UISkinManager.TextColor;
            Color normalColor = UISkinManager.NormalColor;
            Color hoverColor = UISkinManager.HoverColor;

            // Fill entire background
            using (SolidBrush brush = new SolidBrush(baseColor))
            {
                g.FillRectangle(brush, clientRectangle);
            }

            // Draw border around content area
            using (Pen pen = new Pen(borderColor))
            {
                Rectangle r = displayRectangle;
                r.Inflate(SystemInformation.Border3DSize.Width, SystemInformation.Border3DSize.Width);
                g.DrawRectangle(pen, r);
            }

            // Draw all tabs
            for (int i = 0; i < this.TabCount; i++)
            {
                DrawThemedTab(g, this.TabPages[i], i, baseColor, borderColor, textColor, normalColor, hoverColor);
            }

            // Merge selected tab into content area
            if (this.SelectedTab != null && this.SelectedIndex >= 0 && this.SelectedIndex < this.TabCount)
            {
                Rectangle tabRect = this.GetTabRect(this.SelectedIndex);
                using (Pen pen = new Pen(baseColor, 2))
                {
                    if (this.Alignment == TabAlignment.Top)
                    {
                        g.DrawLine(pen, tabRect.Left + 1, tabRect.Bottom, tabRect.Right - 1, tabRect.Bottom);
                    }
                    else if (this.Alignment == TabAlignment.Bottom)
                    {
                        g.DrawLine(pen, tabRect.Left + 1, tabRect.Top, tabRect.Right - 1, tabRect.Top);
                    }
                }
            }
        }

        private void DrawThemedTab(Graphics g, TabPage tabPage, int nIndex, Color baseColor, Color borderColor, Color textColor, Color normalColor, Color hoverColor)
        {
            Rectangle tabRect = this.GetTabRect(nIndex);
            if (tabRect.Width <= 0 || tabRect.Height <= 0) return;

            bool isSelected = (this.SelectedIndex == nIndex);
            bool isHovered = (nIndex == _hoveredIndex && !isSelected);

            Color tabBg;
            if (isSelected) tabBg = baseColor;
            else if (isHovered) tabBg = hoverColor;
            else tabBg = normalColor;

            // Build tab polygon points
            Point[] points;
            if (this.Alignment == TabAlignment.Top)
            {
                points = new Point[]
                {
                    new Point(tabRect.Left, tabRect.Bottom),
                    new Point(tabRect.Left, tabRect.Top + 2),
                    new Point(tabRect.Left + 2, tabRect.Top),
                    new Point(tabRect.Right - 2, tabRect.Top),
                    new Point(tabRect.Right, tabRect.Top + 2),
                    new Point(tabRect.Right, tabRect.Bottom)
                };
            }
            else
            {
                points = new Point[]
                {
                    new Point(tabRect.Left, tabRect.Top),
                    new Point(tabRect.Left, tabRect.Bottom - 2),
                    new Point(tabRect.Left + 2, tabRect.Bottom),
                    new Point(tabRect.Right - 2, tabRect.Bottom),
                    new Point(tabRect.Right, tabRect.Bottom - 2),
                    new Point(tabRect.Right, tabRect.Top)
                };
            }

            using (SolidBrush brush = new SolidBrush(tabBg))
            {
                g.FillPolygon(brush, points);
            }

            using (Pen pen = new Pen(borderColor))
            {
                g.DrawPolygon(pen, points);
            }

            // Draw icon if available
            int textXOffset = 0;
            if (this.ImageList != null && tabPage.ImageIndex >= 0 && tabPage.ImageIndex < this.ImageList.Images.Count)
            {
                Image img = this.ImageList.Images[tabPage.ImageIndex];
                int imgY = tabRect.Y + (tabRect.Height - img.Height) / 2;
                g.DrawImage(img, tabRect.X + 4, imgY, img.Width, img.Height);
                textXOffset = img.Width + 4;
            }

            // Draw text
            Rectangle textRect = new Rectangle(tabRect.X + textXOffset, tabRect.Y, tabRect.Width - textXOffset, tabRect.Height);
            Color currentText = isSelected ? textColor : (isHovered ? textColor : Color.FromArgb(200, textColor.R, textColor.G, textColor.B));

            using (StringFormat sf = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center })
            using (SolidBrush textBrush = new SolidBrush(currentText))
            using (Font tabFont = isSelected ? new Font(this.Font, FontStyle.Bold) : new Font(this.Font, FontStyle.Regular))
            {
                g.DrawString(tabPage.Text, tabFont, textBrush, textRect, sf);
            }
        }
    }
}

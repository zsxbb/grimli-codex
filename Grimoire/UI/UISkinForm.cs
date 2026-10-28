using DarkUI.Forms;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace Grimoire.UI
{
    public partial class UISkinForm : DarkForm
    {
        public static UISkinForm Instance = new UISkinForm();

        private Color _curBase;
        private Color _curNormal;
        private Color _curHover;
        private Color _curPressed;
        private Color _curBorder;
        private Color _curText;
        private Color _curSecondaryText;
        private bool _suppressPresetChange = false;

        private class ThemePreset
        {
            public string Name { get; set; }
            public Color Base { get; set; }
            public Color Normal { get; set; }
            public Color Hover { get; set; }
            public Color Pressed { get; set; }
            public Color Border { get; set; }
            public Color Text { get; set; }
            public Color SecondaryText { get; set; }

            public override string ToString() => Name;
        }

        private readonly List<ThemePreset> _presets = new List<ThemePreset>
        {
            new ThemePreset
            {
                Name = "(Custom)",
                Base = Color.Empty,
                Normal = Color.Empty,
                Hover = Color.Empty,
                Pressed = Color.Empty,
                Border = Color.Empty,
                Text = Color.Empty,
                SecondaryText = Color.Empty
            },
            new ThemePreset
            {
                Name = "Default Dark (Grimlite Li)",
                Base = Color.FromArgb(36, 36, 46),
                Normal = Color.FromArgb(46, 46, 56),
                Hover = Color.FromArgb(90, 90, 100),
                Pressed = Color.FromArgb(43, 43, 53),
                Border = Color.FromArgb(66, 66, 76),
                Text = Color.FromArgb(220, 220, 220),
                SecondaryText = Color.FromArgb(160, 160, 170)
            },
            new ThemePreset
            {
                Name = "CODEX Violet",
                Base = Color.FromArgb(24, 19, 36),
                Normal = Color.FromArgb(56, 39, 82),
                Hover = Color.FromArgb(86, 60, 125),
                Pressed = Color.FromArgb(37, 26, 54),
                Border = Color.FromArgb(138, 87, 216),
                Text = Color.FromArgb(241, 233, 255),
                SecondaryText = Color.FromArgb(180, 165, 205)
            },
            new ThemePreset
            {
                Name = "Cute Sakura",
                Base = Color.FromArgb(243, 222, 240),
                Normal = Color.FromArgb(247, 168, 247),
                Hover = Color.FromArgb(245, 37, 125),
                Pressed = Color.FromArgb(239, 23, 244),
                Border = Color.FromArgb(135, 22, 135),
                Text = Color.FromArgb(64, 0, 2),
                SecondaryText = Color.FromArgb(130, 40, 70)
            },
            new ThemePreset
            {
                Name = "Emerald Matrix",
                Base = Color.FromArgb(15, 30, 21),
                Normal = Color.FromArgb(29, 59, 43),
                Hover = Color.FromArgb(44, 92, 67),
                Pressed = Color.FromArgb(19, 38, 28),
                Border = Color.FromArgb(46, 139, 87),
                Text = Color.FromArgb(230, 255, 240),
                SecondaryText = Color.FromArgb(140, 185, 160)
            },
            new ThemePreset
            {
                Name = "Crimson Shadow",
                Base = Color.FromArgb(34, 18, 21),
                Normal = Color.FromArgb(64, 30, 36),
                Hover = Color.FromArgb(97, 45, 54),
                Pressed = Color.FromArgb(41, 19, 23),
                Border = Color.FromArgb(197, 48, 48),
                Text = Color.FromArgb(255, 235, 235),
                SecondaryText = Color.FromArgb(195, 150, 155)
            },
            new ThemePreset
            {
                Name = "Pitch Black",
                Base = Color.FromArgb(14, 14, 16),
                Normal = Color.FromArgb(27, 27, 32),
                Hover = Color.FromArgb(44, 44, 52),
                Pressed = Color.FromArgb(20, 20, 24),
                Border = Color.FromArgb(68, 68, 80),
                Text = Color.FromArgb(245, 245, 245),
                SecondaryText = Color.FromArgb(150, 150, 155)
            }
        };

        public UISkinForm()
        {
            InitializeComponent();
            PopulatePresets();
            this.pnlColors.BorderStyle = BorderStyle.None;
            this.pnlColors.Paint += (s, e) =>
            {
                using (Pen pen = new Pen(_curBorder))
                {
                    e.Graphics.DrawRectangle(pen, 0, 0, pnlColors.Width - 1, pnlColors.Height - 1);
                }
            };
        }

        private void PopulatePresets()
        {
            if (cbPresets.Items.Count > 0) return;
            _suppressPresetChange = true;
            cbPresets.Items.Clear();
            foreach (var preset in _presets)
            {
                cbPresets.Items.Add(preset);
            }
            _suppressPresetChange = false;
        }

        private void UISkinForm_Load(object sender, EventArgs e)
        {
            PopulatePresets();
            SyncFromActiveColors();
        }

        public void SyncFromActiveColors()
        {
            PopulatePresets();
            _curBase = UISkinManager.BaseColor;
            _curNormal = UISkinManager.NormalColor;
            _curHover = UISkinManager.HoverColor;
            _curPressed = UISkinManager.PressedColor;
            _curBorder = UISkinManager.BorderColor;
            _curText = UISkinManager.TextColor;
            _curSecondaryText = UISkinManager.SecondaryTextColor;

            DetectPreset();
            UpdateUiElements();
        }

        private void DetectPreset()
        {
            PopulatePresets();
            _suppressPresetChange = true;
            int matchedIndex = 0; // (Custom)
            for (int i = 1; i < _presets.Count; i++)
            {
                var p = _presets[i];
                if (ColorsEqual(p.Base, _curBase) &&
                    ColorsEqual(p.Normal, _curNormal) &&
                    ColorsEqual(p.Hover, _curHover) &&
                    ColorsEqual(p.Pressed, _curPressed) &&
                    ColorsEqual(p.Border, _curBorder) &&
                    ColorsEqual(p.Text, _curText) &&
                    ColorsEqual(p.SecondaryText, _curSecondaryText))
                {
                    matchedIndex = i;
                    break;
                }
            }
            if (cbPresets.Items.Count > matchedIndex && matchedIndex >= 0)
            {
                cbPresets.SelectedIndex = matchedIndex;
            }
            _suppressPresetChange = false;
        }

        private bool ColorsEqual(Color c1, Color c2)
        {
            return c1.ToArgb() == c2.ToArgb();
        }

        private void UpdateUiElements()
        {
            pnlBase.BackColor = _curBase;
            lblBaseHex.Text = UISkinManager.ColorToHex(_curBase);

            pnlNormal.BackColor = _curNormal;
            lblNormalHex.Text = UISkinManager.ColorToHex(_curNormal);

            pnlHover.BackColor = _curHover;
            lblHoverHex.Text = UISkinManager.ColorToHex(_curHover);

            pnlPressed.BackColor = _curPressed;
            lblPressedHex.Text = UISkinManager.ColorToHex(_curPressed);

            pnlBorder.BackColor = _curBorder;
            lblBorderHex.Text = UISkinManager.ColorToHex(_curBorder);

            pnlText.BackColor = _curText;
            lblTextHex.Text = UISkinManager.ColorToHex(_curText);

            pnlSecondaryText.BackColor = _curSecondaryText;
            lblSecondaryTextHex.Text = UISkinManager.ColorToHex(_curSecondaryText);
            lblPreviewSecondary.ForeColor = _curSecondaryText;

            cbPresets.BorderColor = _curBorder;
            cbPresets.ButtonColor = _curNormal;
            cbPresets.Invalidate();
            grpPreview.BorderColor = _curBorder;
            grpPreview.Invalidate();
            pnlColors.Invalidate();
        }

        private void cbPresets_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (_suppressPresetChange) return;

            if (cbPresets.SelectedItem is ThemePreset preset && preset.Name != "(Custom)")
            {
                _curBase = preset.Base;
                _curNormal = preset.Normal;
                _curHover = preset.Hover;
                _curPressed = preset.Pressed;
                _curBorder = preset.Border;
                _curText = preset.Text;
                _curSecondaryText = preset.SecondaryText;

                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnPickBase_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = _curBase;
            if (colorDialog1.ShowDialog(this) == DialogResult.OK)
            {
                _curBase = colorDialog1.Color;
                _suppressPresetChange = true;
                cbPresets.SelectedIndex = 0; // (Custom)
                _suppressPresetChange = false;
                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnPickNormal_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = _curNormal;
            if (colorDialog1.ShowDialog(this) == DialogResult.OK)
            {
                _curNormal = colorDialog1.Color;
                _suppressPresetChange = true;
                cbPresets.SelectedIndex = 0; // (Custom)
                _suppressPresetChange = false;
                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnPickHover_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = _curHover;
            if (colorDialog1.ShowDialog(this) == DialogResult.OK)
            {
                _curHover = colorDialog1.Color;
                _suppressPresetChange = true;
                cbPresets.SelectedIndex = 0; // (Custom)
                _suppressPresetChange = false;
                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnPickPressed_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = _curPressed;
            if (colorDialog1.ShowDialog(this) == DialogResult.OK)
            {
                _curPressed = colorDialog1.Color;
                _suppressPresetChange = true;
                cbPresets.SelectedIndex = 0; // (Custom)
                _suppressPresetChange = false;
                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnPickBorder_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = _curBorder;
            if (colorDialog1.ShowDialog(this) == DialogResult.OK)
            {
                _curBorder = colorDialog1.Color;
                _suppressPresetChange = true;
                cbPresets.SelectedIndex = 0; // (Custom)
                _suppressPresetChange = false;
                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnPickText_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = _curText;
            if (colorDialog1.ShowDialog(this) == DialogResult.OK)
            {
                _curText = colorDialog1.Color;
                _suppressPresetChange = true;
                cbPresets.SelectedIndex = 0; // (Custom)
                _suppressPresetChange = false;
                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnPickSecondaryText_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = _curSecondaryText;
            if (colorDialog1.ShowDialog(this) == DialogResult.OK)
            {
                _curSecondaryText = colorDialog1.Color;
                _suppressPresetChange = true;
                cbPresets.SelectedIndex = 0; // (Custom)
                _suppressPresetChange = false;
                UpdateUiElements();
                UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
            }
        }

        private void btnApply_Click(object sender, EventArgs e)
        {
            UISkinManager.Apply(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText, true);
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            UISkinManager.Save(_curBase, _curNormal, _curHover, _curPressed, _curBorder, _curText, _curSecondaryText);
            DarkMessageBox.Show(this, "Skin settings successfully saved to config!", "UI Skins", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            var result = DarkMessageBox.Show(
                this,
                "Are you sure you want to reset button colors to the default dark theme?",
                "Reset UI Skin",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Warning);

            if (result == DialogResult.Yes)
            {
                UISkinManager.ResetToDefault();
                SyncFromActiveColors();
            }
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Hide();
        }

        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
            base.OnFormClosing(e);
        }
    }
}

using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Windows.Forms;
using DarkUI.Config;
using DarkUI.Controls;
using Grimoire.Botting;

namespace Grimoire.UI
{
    public static class UISkinManager
    {
        // Default Grimoire DarkUI colors
        public static readonly Color DefaultBase = Color.FromArgb(36, 36, 46);
        public static readonly Color DefaultNormal = Color.FromArgb(46, 46, 56);
        public static readonly Color DefaultHover = Color.FromArgb(90, 90, 100);
        public static readonly Color DefaultPressed = Color.FromArgb(43, 43, 53);
        public static readonly Color DefaultBorder = Color.FromArgb(66, 66, 76);
        public static readonly Color DefaultText = Color.FromArgb(220, 220, 220);

        // Permanent default dark colors for inner Bot windows/lists
        public static readonly Color PermanentDarkBackground = Color.FromArgb(36, 36, 46);
        public static readonly Color PermanentDarkText = Color.Gainsboro;
        public static readonly Color PermanentDarkPanel = Color.FromArgb(34, 34, 34);

        // Active Colors
        public static Color BaseColor { get; set; } = DefaultBase;
        public static Color NormalColor { get; set; } = DefaultNormal;
        public static Color HoverColor { get; set; } = DefaultHover;
        public static Color PressedColor { get; set; } = DefaultPressed;
        public static Color BorderColor { get; set; } = DefaultBorder;
        public static Color TextColor { get; set; } = DefaultText;

        private static readonly HashSet<int> KnownBaseArgb = new HashSet<int>
        {
            Color.FromArgb(36, 36, 46).ToArgb(),
            Color.FromArgb(34, 34, 34).ToArgb(),
            Color.FromArgb(30, 30, 30).ToArgb(),
            Color.FromArgb(36, 36, 36).ToArgb(),
            Color.FromArgb(43, 43, 53).ToArgb(),
            Color.FromArgb(46, 46, 56).ToArgb()
        };

        public static string ConfigPath => Path.Combine(Application.StartupPath, "config.cfg");

        public static void Init()
        {
            try
            {
                Config c = Config.Load(ConfigPath);
                BaseColor = ParseColor(c.Get("BtnBaseColor"), DefaultBase);
                NormalColor = ParseColor(c.Get("BtnNormalColor"), DefaultNormal);
                HoverColor = ParseColor(c.Get("BtnHoverColor"), DefaultHover);
                PressedColor = ParseColor(c.Get("BtnPressedColor"), DefaultPressed);
                BorderColor = ParseColor(c.Get("BtnBorderColor"), DefaultBorder);
                TextColor = ParseColor(c.Get("BtnTextColor"), DefaultText);

                KnownBaseArgb.Add(BaseColor.ToArgb());
                ApplyColorsToDarkUI();
            }
            catch { }
        }

        public static void Apply(Color baseColor, Color normal, Color hover, Color pressed, Color border, Color text, bool refreshUi = true)
        {
            BaseColor = baseColor;
            NormalColor = normal;
            HoverColor = hover;
            PressedColor = pressed;
            BorderColor = border;
            TextColor = text;

            KnownBaseArgb.Add(baseColor.ToArgb());
            ApplyColorsToDarkUI();

            if (refreshUi)
            {
                RefreshAllForms();
            }
        }

        public static void Save(Color baseColor, Color normal, Color hover, Color pressed, Color border, Color text)
        {
            try
            {
                Apply(baseColor, normal, hover, pressed, border, text, true);

                Config c = Config.Load(ConfigPath);
                c.Set("BtnBaseColor", baseColor.ToArgb().ToString("X8"));
                c.Set("BtnNormalColor", normal.ToArgb().ToString("X8"));
                c.Set("BtnHoverColor", hover.ToArgb().ToString("X8"));
                c.Set("BtnPressedColor", pressed.ToArgb().ToString("X8"));
                c.Set("BtnBorderColor", border.ToArgb().ToString("X8"));
                c.Set("BtnTextColor", text.ToArgb().ToString("X8"));
                c.Save();
            }
            catch { }
        }

        public static void ResetToDefault()
        {
            Save(DefaultBase, DefaultNormal, DefaultHover, DefaultPressed, DefaultBorder, DefaultText);
        }

        private static void ApplyColorsToDarkUI()
        {
            SetColorField("GreyBackground", BaseColor);
            SetColorField("HeaderBackground", BaseColor);
            SetColorField("LightBackground", NormalColor);
            SetColorField("MediumBackground", NormalColor);
            SetColorField("LighterBackground", HoverColor);
            SetColorField("DarkBackground", PressedColor);
            SetColorField("GreySelection", BorderColor);
            SetColorField("DarkGreySelection", BorderColor);
            SetColorField("LightBorder", BorderColor);
            SetColorField("DarkBorder", BorderColor);
            SetColorField("DarkBlueBorder", BorderColor);
            SetColorField("LightBlueBorder", BorderColor);
            SetColorField("LightText", TextColor);
            SetColorField("GreyHighlight", HoverColor);
            SetColorField("BlueHighlight", HoverColor);
            SetColorField("BlueSelection", HoverColor);
        }

        private static void SetColorField(string propertyName, Color color)
        {
            try
            {
                var field = typeof(Colors).GetField($"<{propertyName}>k__BackingField", BindingFlags.Static | BindingFlags.NonPublic);
                if (field != null)
                {
                    field.SetValue(null, color);
                    return;
                }

                var prop = typeof(Colors).GetProperty(propertyName, BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
                prop?.SetValue(null, color, null);
            }
            catch { }
        }

        public static void RefreshAllForms()
        {
            try
            {
                foreach (Form form in Application.OpenForms.Cast<Form>().ToList())
                {
                    ApplyThemeToControl(form);
                    form.Invalidate(true);
                }
            }
            catch { }
        }

        public static void ApplyThemeToControl(Control ctrl)
        {
            if (ctrl == null) return;

            if (ctrl is Form f)
            {
                f.BackColor = BaseColor;
            }
            else if (ctrl is FlatTabControl.FlatTabControl ftc)
            {
                ftc.myBackColor = BaseColor;
                ftc.BackColor = BaseColor;
                ftc.ForeColor = TextColor;
                foreach (TabPage page in ftc.TabPages)
                {
                    page.BackColor = BaseColor;
                    page.ForeColor = TextColor;
                }
                ftc.Invalidate(true);
            }
            else if (ctrl is TabPage tp)
            {
                tp.BackColor = BaseColor;
                tp.ForeColor = TextColor;
            }
            else if (ctrl is MenuStrip ms)
            {
                ms.BackColor = BaseColor;
                ms.ForeColor = TextColor;
                foreach (ToolStripItem item in ms.Items)
                {
                    ApplyThemeToMenuItem(item);
                }
                ms.Invalidate();
            }
            else if (ctrl is ContextMenuStrip cms)
            {
                cms.BackColor = BaseColor;
                cms.ForeColor = TextColor;
                foreach (ToolStripItem item in cms.Items)
                {
                    ApplyThemeToMenuItem(item);
                }
                cms.Invalidate();
            }
            else if (ctrl is ToolStrip ts)
            {
                ts.BackColor = BaseColor;
                ts.ForeColor = TextColor;
                foreach (ToolStripItem item in ts.Items)
                {
                    ApplyThemeToMenuItem(item);
                }
                ts.Invalidate();
            }
            else if (ctrl is DarkGroupBox gb)
            {
                gb.BackColor = BaseColor;
                gb.BorderColor = BorderColor;
                gb.ForeColor = TextColor;
                gb.Invalidate();
            }
            else if (ctrl is DarkTextBox dtb)
            {
                dtb.BackColor = NormalColor;
                dtb.ForeColor = TextColor;
                dtb.Invalidate();
            }
            else if (ctrl is DarkComboBox dcb)
            {
                dcb.BackColor = NormalColor;
                dcb.ForeColor = TextColor;
                dcb.BorderColor = BorderColor;
                dcb.ButtonColor = NormalColor;
                dcb.Invalidate();
            }
            else if (ctrl is DarkNumericUpDown nud)
            {
                nud.BackColor = NormalColor;
                nud.ForeColor = TextColor;
                nud.Invalidate();
            }
            else if (ctrl is DarkButton btn)
            {
                btn.ForeColor = TextColor;
                btn.Invalidate();
            }
            else if (ctrl is DarkCheckBox dcb2)
            {
                if (dcb2.BackColor != Color.Transparent)
                    dcb2.BackColor = BaseColor;
                dcb2.ForeColor = TextColor;
                dcb2.Invalidate();
            }
            else if (ctrl is DarkRadioButton drb)
            {
                if (drb.BackColor != Color.Transparent)
                    drb.BackColor = BaseColor;
                drb.ForeColor = TextColor;
                drb.Invalidate();
            }
            else if (ctrl is DarkLabel dl)
            {
                dl.ForeColor = TextColor;
            }
            else if (ctrl is CheckBox cb)
            {
                if (IsBaseColor(cb.BackColor)) cb.BackColor = BaseColor;
                cb.ForeColor = TextColor;
                cb.Invalidate();
            }
            else if (ctrl is RadioButton rb)
            {
                if (IsBaseColor(rb.BackColor)) rb.BackColor = BaseColor;
                rb.ForeColor = TextColor;
                rb.Invalidate();
            }
            else if (ctrl is Label lbl)
            {
                lbl.ForeColor = TextColor;
            }
            else if (ctrl is ListBox lb)
            {
                if (IsPermanentDarkBotControl(lb))
                {
                    lb.BackColor = PermanentDarkBackground;
                    lb.ForeColor = PermanentDarkText;
                }
                else
                {
                    if (IsBaseColor(lb.BackColor))
                    {
                        lb.BackColor = BaseColor;
                    }
                    lb.ForeColor = TextColor;
                }
                lb.Invalidate();
            }
            else if (ctrl is DarkTreeView dtv)
            {
                if (IsPermanentDarkBotControl(dtv))
                {
                    dtv.BackColor = PermanentDarkBackground;
                    dtv.ForeColor = PermanentDarkText;
                }
                else
                {
                    if (IsBaseColor(dtv.BackColor)) dtv.BackColor = BaseColor;
                    dtv.ForeColor = TextColor;
                }
                try
                {
                    var field = typeof(DarkTreeView).GetField("_borderColor", BindingFlags.Instance | BindingFlags.NonPublic);
                    field?.SetValue(dtv, BorderColor);
                }
                catch { }
                dtv.Invalidate();
            }
            else if (ctrl is TreeView tv)
            {
                if (IsPermanentDarkBotControl(tv))
                {
                    tv.BackColor = PermanentDarkBackground;
                    tv.ForeColor = PermanentDarkText;
                }
                else
                {
                    if (IsBaseColor(tv.BackColor))
                    {
                        tv.BackColor = BaseColor;
                    }
                    tv.ForeColor = TextColor;
                }
                tv.Invalidate();
            }
            else if (ctrl is RichTextBox rtb)
            {
                if (IsPermanentDarkBotControl(rtb))
                {
                    rtb.BackColor = PermanentDarkBackground;
                    rtb.ForeColor = PermanentDarkText;
                }
                else
                {
                    if (IsBaseColor(rtb.BackColor))
                    {
                        rtb.BackColor = BaseColor;
                    }
                    rtb.ForeColor = TextColor;
                }
            }
            else if (ctrl is SplitContainer sc)
            {
                sc.BackColor = BaseColor;
                sc.Panel1.BackColor = BaseColor;
                if (IsBaseColor(sc.Panel2.BackColor)) sc.Panel2.BackColor = BaseColor;
            }
            else if (ctrl is Panel p)
            {
                if (IsPermanentDarkBotPanel(p))
                {
                    p.BackColor = PermanentDarkPanel;
                }
                // Do not color preview panels in UISkinForm
                else if (p.Name != "pnlBase" && p.Name != "pnlNormal" && p.Name != "pnlHover" &&
                    p.Name != "pnlPressed" && p.Name != "pnlBorder" && p.Name != "pnlText")
                {
                    if (p.Name == "pnlMenuControls" || IsBaseColor(p.BackColor))
                    {
                        p.BackColor = BaseColor;
                    }
                }
            }

            foreach (Control child in ctrl.Controls)
            {
                ApplyThemeToControl(child);
            }
        }

        public static void ApplyThemeToMenuItem(ToolStripItem item)
        {
            if (item == null) return;
            item.BackColor = BaseColor;
            item.ForeColor = TextColor;
            if (item is ToolStripMenuItem mi)
            {
                foreach (ToolStripItem sub in mi.DropDownItems)
                {
                    ApplyThemeToMenuItem(sub);
                }
            }
        }

        public static bool IsPermanentDarkBotControl(Control ctrl)
        {
            if (ctrl == null) return false;

            string name = ctrl.Name;
            if (name == "lstCommands" || name == "lstDrops" || name == "lstBoosts" ||
                name == "lstQuests" || name == "lstSkills" || name == "lstItems" ||
                name == "treeBots" || name == "lbLabels" || name == "lstLogText" ||
                name == "lstSoundItems" || name == "rtbInfo" || name == "richTextBox2")
            {
                return true;
            }

            Form form = ctrl.FindForm();
            if (form is BotManager || (form != null && form.GetType().Name == "BotManager"))
            {
                if (ctrl is ListBox || ctrl is TreeView || ctrl is RichTextBox || ctrl is DarkTreeView)
                {
                    return true;
                }
            }

            Control top = ctrl;
            while (top != null)
            {
                if (top is BotManager || top.GetType().Name == "BotManager")
                {
                    if (ctrl is ListBox || ctrl is TreeView || ctrl is RichTextBox || ctrl is DarkTreeView)
                    {
                        return true;
                    }
                    break;
                }
                top = top.Parent;
            }

            return false;
        }

        public static bool IsPermanentDarkBotPanel(Control ctrl)
        {
            if (ctrl == null) return false;
            if (ctrl.Name == "panel1")
            {
                Form form = ctrl.FindForm();
                if (form is BotManager || (form != null && form.GetType().Name == "BotManager"))
                    return true;

                Control top = ctrl;
                while (top != null)
                {
                    if (top is BotManager || top.GetType().Name == "BotManager")
                        return true;
                    top = top.Parent;
                }
            }
            return false;
        }

        public static bool IsBaseColor(Color c)
        {
            int argb = c.ToArgb();
            return argb == BaseColor.ToArgb() || KnownBaseArgb.Contains(argb);
        }

        public static Color ParseColor(string hex, Color defaultColor)
        {
            if (string.IsNullOrWhiteSpace(hex)) return defaultColor;
            try
            {
                if (int.TryParse(hex, System.Globalization.NumberStyles.HexNumber, null, out int argb))
                {
                    return Color.FromArgb(argb);
                }
            }
            catch { }
            return defaultColor;
        }

        public static string ColorToHex(Color color)
        {
            return $"#{color.R:X2}{color.G:X2}{color.B:X2}";
        }
    }
}

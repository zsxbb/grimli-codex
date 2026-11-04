using System.Windows.Forms;
using DarkUI.Forms;

namespace Grimoire.UI
{
    public class GrimDarkForm : DarkForm
    {
        protected override CreateParams CreateParams
        {
            get
            {
                CreateParams cp = base.CreateParams;
                cp.ExStyle |= 0x02000000; // WS_EX_COMPOSITED: smooth flicker-free double buffering for all child controls
                return cp;
            }
        }
    }
}


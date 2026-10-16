using System;
using System.Windows.Forms;
using System.Threading.Tasks;
using DarkUI.Forms;
using Grimoire.Game;
using Grimoire.Game.Data;
using Grimoire.Tools;
using Grimoire.Networking;

namespace Grimoire.UI
{
    public partial class BypassMapForm : DarkForm
    {
        public static BypassMapForm Instance { get; } = new BypassMapForm();

        private BypassMapForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private void BypassMapForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }

        private void btnBypassAll_Click(object sender, EventArgs e)
        {
            if (!Player.IsLoggedIn)
            {
                MessageBox.Show("Please log in first.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string sekai = "world.myAvatar.objData.";
            for (int i = 1; i <= 7; i++)
            {
                string key = i == 1 ? "strQuests" : $"strQuests{i}";
                string ambatu = Flash.GetGameObject(sekai + key).Replace("\"", "");
                Flash.SetGameObject(sekai + key, new String('Z', ambatu.Length));
            }
            MessageBox.Show(
                "All MAP and STORYLINES have been bypassed.\n* Storylines Unlocked\n* Monsters are now visible\n\nNote: This is client-side only. If you want to restore your account's original progress, please relog.", 
                "Success",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
    }
}

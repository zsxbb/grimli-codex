using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Threading.Tasks;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Game;
using Grimoire.Tools;

namespace Grimoire.UI
{
	public partial class AboutForm : DarkForm
	{
		public AboutForm()
		{
			InitializeComponent();
			this.appName.Text = $"Grimlite Li x CODEX v{CodexBankManager.CURRENT_APP_VERSION}";
			this.lblVersion.Text = $"v{CodexBankManager.CURRENT_APP_VERSION} ({Program.ReleaseDate}) x CODEX";
		}

		private void AboutForm_FormClosing(object sender, FormClosingEventArgs e)
		{
			if (e.CloseReason == CloseReason.UserClosing)
			{
				e.Cancel = true;
				Hide();
			}
		}

		private void pbFrozttGithub_Click(object sender, EventArgs e)
		{
			Process.Start("https://github.com/Froztt13/Grimlite-Li");
		}

		private void pbVicinity4519Github_Click(object sender, EventArgs e)
		{
			Process.Start("https://github.com/Vicinity4519/Grimlite-Li");
		}

        private void pictureBox1_Click(object sender, EventArgs e)
        {
        }

        private void pbBuyCoffee_Click(object sender, EventArgs e)
		{
			Process.Start("https://sociabuzz.com/sxbb/tribe");
		}

		private void lblBuyCoffee_Click(object sender, EventArgs e)
		{
			Process.Start("https://sociabuzz.com/sxbb/tribe");
		}

		private void pbCatGithub_Click(object sender, EventArgs e)
		{
			Process.Start("https://github.com/0zl");
		}

		private void pbsatanGithub_Click(object sender, EventArgs e)
		{
			Process.Start("https://github.com/wispie");
		}

		private void pbZee_Click(object sender, EventArgs e)
		{
			Process.Start("https://ko-fi.com/zeesnuts");
		}

		private void lblZee_Click(object sender, EventArgs e)
		{
			Process.Start("https://ko-fi.com/zeesnuts");
		}

		private void AboutForm_Load(object sender, EventArgs e)
		{
			bool latest = false;
			//int version = version whatever  
			if (latest)
			{
				//lblUpdate = $"Grimlite is up to date ({version})"
			}
			else
			{
				//int latestVersion = latest version or whatever
				//bool latestStatus
				//lblUpdate = $"Latest {latestVersion}, status: {latestStatus ? "Released" : "Unreleased"}"
				
				// I'll handle the Released or Unreleased with color (green = released, red = unreleased)
			}

		}

		private async void btnLoadSWF_Click(object sender, EventArgs e)
		{
			bool fileExist = File.Exists(Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), tbGameSWF.Text));
			if (!fileExist)
			{
				lblSwfInfo.Text = "File not found.";
				return;
			}

			btnLoadSWF.Enabled = false;
			BotManager.Instance.chkEnable.Checked = false;
			if (Player.IsLoggedIn) Player.Logout();
			Root.Instance.InitFlashMovie(tbGameSWF.Text);
			Root.Instance.LoadCharSelect();
			await Task.Delay(2000);
			btnLoadSWF.Enabled = true;
			lblSwfInfo.Text = "";
		}

		//required to checking version in some existing plugins
		public string getVersion()
		{
			return $"Version 2.3 ({Program.ReleaseDate.Replace("-", "")})";
		}

        
    }
}

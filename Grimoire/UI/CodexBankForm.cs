using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Threading.Tasks;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Tools;

namespace Grimoire.UI
{
    public partial class CodexBankForm : DarkForm
    {
        public static CodexBankForm Instance { get; } = new CodexBankForm();

        private bool _isBusy = false;

        private CodexBankForm()
        {
            InitializeComponent();
            this.TopMost = true;
        }

        private async void CodexBankForm_Load(object sender, EventArgs e)
        {
            lblVersionInfo.Text = $"App Version: {CodexBankManager.CURRENT_APP_VERSION}";
            await RefreshManifestAsync();
        }

        private void CodexBankForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }

        public async Task RefreshManifestAsync()
        {
            if (_isBusy) return;

            SetBusyState(true, "Fetching script manifest from GitHub...");
            progressBar.Value = 30;

            try
            {
                CodexManifest manifest = await CodexBankManager.Instance.FetchManifestAsync();
                progressBar.Value = 100;

                if (manifest != null)
                {
                    PopulateListView(manifest);

                    if (CodexBankManager.Instance.IsAppUpdateAvailable(manifest))
                    {
                        lblVersionInfo.Text = $"v{CodexBankManager.CURRENT_APP_VERSION} (Update: v{manifest.AppVersion}!)";
                        lblVersionInfo.ForeColor = Color.Gold;
                        lblStatus.Text = $"Update v{manifest.AppVersion} is available! Click 'Check App Update'.";
                    }
                    else
                    {
                        lblVersionInfo.Text = $"v{CodexBankManager.CURRENT_APP_VERSION} (Latest)";
                        lblVersionInfo.ForeColor = Color.FromArgb(160, 220, 160);
                        lblStatus.Text = $"Loaded {manifest.Scripts.Count} scripts from Codex Cloud Bank.";
                    }
                }
                else
                {
                    lblStatus.Text = "Failed to parse manifest from GitHub.";
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = $"Error loading manifest: {ex.Message}";
            }
            finally
            {
                SetBusyState(false);
                progressBar.Value = 0;
            }
        }

        private void PopulateListView(CodexManifest manifest)
        {
            lvScripts.BeginUpdate();
            lvScripts.Items.Clear();

            if (manifest?.Scripts != null)
            {
                foreach (var script in manifest.Scripts)
                {
                    ListViewItem lvi = new ListViewItem(script.Name);
                    lvi.SubItems.Add(script.Category ?? "General");
                    
                    var statusSubItem = lvi.SubItems.Add(script.StatusDisplay);
                    lvi.SubItems.Add(script.Description ?? "");

                    lvi.Tag = script;

                    switch (script.Status)
                    {
                        case ScriptStatus.UpToDate:
                            statusSubItem.ForeColor = Color.LightGreen;
                            break;
                        case ScriptStatus.UpdateAvailable:
                            statusSubItem.ForeColor = Color.Gold;
                            break;
                        case ScriptStatus.Missing:
                            statusSubItem.ForeColor = Color.FromArgb(200, 180, 180);
                            break;
                        case ScriptStatus.Failed:
                            statusSubItem.ForeColor = Color.Tomato;
                            break;
                    }

                    lvScripts.Items.Add(lvi);
                }
            }

            lvScripts.EndUpdate();
        }

        private async void btnSyncAll_Click(object sender, EventArgs e)
        {
            if (_isBusy) return;

            SetBusyState(true, "Synchronizing all scripts...");
            progressBar.Value = 0;

            var progress = new Progress<(string message, int progress)>(val =>
            {
                lblStatus.Text = val.message;
                progressBar.Value = Math.Max(0, Math.Min(100, val.progress));
            });

            try
            {
                SyncResult result = await CodexBankManager.Instance.SyncAllScriptsAsync(progress);

                if (CodexBankManager.Instance.CachedManifest != null)
                {
                    PopulateListView(CodexBankManager.Instance.CachedManifest);
                }

                if (result.Failed == 0)
                {
                    lblStatus.Text = $"Sync complete! {result.Updated} scripts up to date in Bots/CodexBank.";
                    MessageBox.Show($"Successfully synced {result.Updated} scripts to Bots/CodexBank!", "Codex Script Bank", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    lblStatus.Text = $"Sync finished with {result.Failed} errors.";
                    MessageBox.Show($"Synced with {result.Failed} errors:\r\n" + string.Join("\r\n", result.Errors), "Sync Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = $"Sync error: {ex.Message}";
                MessageBox.Show("Sync failed: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                SetBusyState(false);
                progressBar.Value = 0;
            }
        }

        private async void btnSyncSelected_Click(object sender, EventArgs e)
        {
            if (_isBusy) return;
            if (lvScripts.SelectedItems.Count == 0)
            {
                MessageBox.Show("Please select at least one script to sync.", "Codex Script Bank", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            SetBusyState(true, "Syncing selected scripts...");
            int total = lvScripts.SelectedItems.Count;
            int current = 0;

            try
            {
                foreach (ListViewItem item in lvScripts.SelectedItems)
                {
                    if (item.Tag is CodexScriptItem script)
                    {
                        current++;
                        lblStatus.Text = $"Downloading {script.Name} ({current}/{total})...";
                        progressBar.Value = (int)((double)current / total * 100);

                        bool ok = await CodexBankManager.Instance.DownloadScriptAsync(script);
                        script.Status = ok ? ScriptStatus.UpToDate : ScriptStatus.Failed;
                    }
                }

                if (CodexBankManager.Instance.CachedManifest != null)
                {
                    PopulateListView(CodexBankManager.Instance.CachedManifest);
                }

                lblStatus.Text = $"Finished syncing {total} selected script(s).";
            }
            catch (Exception ex)
            {
                lblStatus.Text = $"Sync error: {ex.Message}";
            }
            finally
            {
                SetBusyState(false);
                progressBar.Value = 0;
            }
        }

        private async void btnRefresh_Click(object sender, EventArgs e)
        {
            await RefreshManifestAsync();
        }

        private void btnOpenFolder_Click(object sender, EventArgs e)
        {
            CodexBankManager.Instance.EnsureBankFolderExists();
            string folder = CodexBankManager.Instance.LocalBankDirectory;

            try
            {
                Process.Start("explorer.exe", folder);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to open folder: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private async void btnCheckAppUpdate_Click(object sender, EventArgs e)
        {
            await CodexBankManager.Instance.CheckAppUpdatePromptAsync();
        }

        private void SetBusyState(bool busy, string statusText = null)
        {
            _isBusy = busy;
            btnSyncAll.Enabled = !busy;
            btnSyncSelected.Enabled = !busy;
            btnRefresh.Enabled = !busy;
            btnCheckAppUpdate.Enabled = !busy;

            if (statusText != null)
            {
                lblStatus.Text = statusText;
            }
        }
    }
}

using System;
using System.IO;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using DarkUI.Forms;
using Grimoire.Tools;

namespace Grimoire.UI
{
    public partial class AppUpdateDialog : DarkForm
    {
        private readonly CodexManifest _manifest;
        private CancellationTokenSource _cts;
        private bool _isUpdating = false;

        public AppUpdateDialog(CodexManifest manifest)
        {
            InitializeComponent();
            _manifest = manifest;
            this.TopMost = true;
        }

        private async void AppUpdateDialog_Load(object sender, EventArgs e)
        {
            if (_manifest == null || string.IsNullOrEmpty(_manifest.AppDownloadUrl))
            {
                MessageBox.Show("No download URL found for this release.", "Update Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
                return;
            }

            lblTitle.Text = $"Downloading Grimlite Li x CODEX v{_manifest.AppVersion}...";
            _cts = new CancellationTokenSource();
            _isUpdating = true;

            await StartDownloadAsync(_cts.Token);
        }

        private async Task StartDownloadAsync(CancellationToken cancellationToken)
        {
            string targetPath = Path.Combine(Application.StartupPath, "Grimoire.exe.new");

            try
            {
                using (HttpClient client = new HttpClient())
                {
                    client.Timeout = TimeSpan.FromMinutes(10);
                    client.DefaultRequestHeaders.Add("User-Agent", "Grimlite-Codex-Client");

                    using (HttpResponseMessage response = await client.GetAsync(_manifest.AppDownloadUrl, HttpCompletionOption.ResponseHeadersRead, cancellationToken))
                    {
                        response.EnsureSuccessStatusCode();

                        long? totalBytes = response.Content.Headers.ContentLength;

                        using (Stream contentStream = await response.Content.ReadAsStreamAsync())
                        using (FileStream fileStream = new FileStream(targetPath, FileMode.Create, FileAccess.Write, FileShare.None, 8192, true))
                        {
                            byte[] buffer = new byte[8192];
                            long totalRead = 0;
                            int bytesRead;

                            while ((bytesRead = await contentStream.ReadAsync(buffer, 0, buffer.Length, cancellationToken)) > 0)
                            {
                                await fileStream.WriteAsync(buffer, 0, bytesRead, cancellationToken);
                                totalRead += bytesRead;

                                if (totalBytes.HasValue && totalBytes.Value > 0)
                                {
                                    int progressPct = (int)((double)totalRead / totalBytes.Value * 100);
                                    progressBar.Value = Math.Max(0, Math.Min(100, progressPct));

                                    double readMb = totalRead / (1024.0 * 1024.0);
                                    double totalMb = totalBytes.Value / (1024.0 * 1024.0);
                                    lblStatus.Text = $"Downloading: {readMb:F1} MB / {totalMb:F1} MB ({progressPct}%)...";
                                }
                                else
                                {
                                    double readMb = totalRead / (1024.0 * 1024.0);
                                    lblStatus.Text = $"Downloading: {readMb:F1} MB...";
                                }
                            }
                        }
                    }
                }

                // Download completed successfully
                progressBar.Value = 100;
                lblStatus.Text = "Download completed! Restarting application...";
                btnCancel.Enabled = false;

                await Task.Delay(1500);

                // Apply update and restart
                CodexBankManager.ApplyUpdateAndRestart(targetPath);
            }
            catch (OperationCanceledException)
            {
                lblStatus.Text = "Update cancelled.";
                TryDeleteFile(targetPath);
                Close();
            }
            catch (Exception ex)
            {
                TryDeleteFile(targetPath);
                _isUpdating = false;
                MessageBox.Show($"Update failed: {ex.Message}", "Update Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            if (_isUpdating && _cts != null && !_cts.IsCancellationRequested)
            {
                _cts.Cancel();
            }
            else
            {
                Close();
            }
        }

        private void AppUpdateDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (_isUpdating && _cts != null && !_cts.IsCancellationRequested)
            {
                _cts.Cancel();
            }
        }

        private void TryDeleteFile(string path)
        {
            try
            {
                if (File.Exists(path)) File.Delete(path);
            }
            catch { }
        }
    }
}

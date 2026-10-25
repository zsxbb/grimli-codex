using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Grimoire.UI;
using Newtonsoft.Json;

namespace Grimoire.Tools
{
    public enum ScriptStatus
    {
        Missing,
        UpdateAvailable,
        UpToDate,
        Failed
    }

    public class CodexScriptItem
    {
        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("credit")]
        public string Credit { get; set; } = "-";

        [JsonProperty("description")]
        public string Description { get; set; } = "";

        [JsonProperty("download_url")]
        public string DownloadUrl { get; set; }

        [JsonProperty("sha256")]
        public string Sha256 { get; set; }

        [JsonIgnore]
        public ScriptStatus Status { get; set; } = ScriptStatus.Missing;

        [JsonIgnore]
        public string StatusDisplay
        {
            get
            {
                switch (Status)
                {
                    case ScriptStatus.UpToDate:
                        return "Up to Date";
                    case ScriptStatus.UpdateAvailable:
                        return "Update Available";
                    case ScriptStatus.Missing:
                        return "Not Downloaded";
                    case ScriptStatus.Failed:
                        return "Sync Failed";
                    default:
                        return "Unknown";
                }
            }
        }
    }

    public class CodexManifest
    {
        [JsonProperty("app_version")]
        public string AppVersion { get; set; } = "2.0";

        [JsonProperty("app_download_url")]
        public string AppDownloadUrl { get; set; } = "https://github.com/zsxbb/grimli-codex/releases/latest/download/Grimoire.exe";

        [JsonProperty("app_release_url")]
        public string AppReleaseUrl { get; set; } = "https://github.com/zsxbb/grimli-codex/releases/latest";

        [JsonProperty("changelog")]
        public string Changelog { get; set; } = "";

        [JsonProperty("scripts")]
        public List<CodexScriptItem> Scripts { get; set; } = new List<CodexScriptItem>();
    }

    public class SyncResult
    {
        public int Total { get; set; }
        public int Updated { get; set; }
        public int Skipped { get; set; }
        public int Failed { get; set; }
        public List<string> Errors { get; } = new List<string>();
    }

    public class CodexBankManager
    {
        public static CodexBankManager Instance { get; } = new CodexBankManager();

        public const string MANIFEST_URL = "https://raw.githubusercontent.com/zsxbb/grimli-codex/main/CodexBank/manifest.json";
        public const string RAW_BASE_URL = "https://raw.githubusercontent.com/zsxbb/grimli-codex/main/CodexBank/";
        public const string CURRENT_APP_VERSION = "2.0.6";

        public string LocalBankDirectory => Path.Combine(Application.StartupPath, "Bots", "CodexBank");

        public CodexManifest CachedManifest { get; private set; }

        private CodexBankManager()
        {
            try
            {
                // Ensure TLS 1.2 is active for modern GitHub HTTPS connections
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
            }
            catch { }
        }

        public void EnsureBankFolderExists()
        {
            try
            {
                if (!Directory.Exists(LocalBankDirectory))
                {
                    Directory.CreateDirectory(LocalBankDirectory);
                }
            }
            catch { }
        }

        public event Action<bool> UpdateAvailabilityChanged;

        public async Task<CodexManifest> FetchManifestAsync()
        {
            using (HttpClient client = CreateHttpClient())
            {
                string url = $"{MANIFEST_URL}?t={DateTimeOffset.UtcNow.ToUnixTimeSeconds()}";
                string json = await client.GetStringAsync(url);
                CodexManifest manifest = JsonConvert.DeserializeObject<CodexManifest>(json);

                if (manifest != null)
                {
                    CachedManifest = manifest;
                    RefreshLocalStatus(manifest);
                    try
                    {
                        UpdateAvailabilityChanged?.Invoke(IsAppUpdateAvailable(manifest));
                    }
                    catch { }
                }

                return manifest;
            }
        }

        public string GetScriptRelativePath(CodexScriptItem script)
        {
            if (script == null || string.IsNullOrEmpty(script.Name)) return "";
            string name = script.Name.Replace('\\', '/').Trim('/', ' ');
            if (name.Contains(".."))
            {
                name = Path.GetFileName(name);
            }
            return name.Replace('/', Path.DirectorySeparatorChar);
        }

        public string GetScriptLocalPath(CodexScriptItem script)
        {
            string rel = GetScriptRelativePath(script);
            return Path.Combine(LocalBankDirectory, rel);
        }

        public void RefreshLocalStatus(CodexManifest manifest)
        {
            if (manifest == null || manifest.Scripts == null) return;

            EnsureBankFolderExists();

            foreach (var script in manifest.Scripts)
            {
                string localPath = GetScriptLocalPath(script);

                if (!File.Exists(localPath))
                {
                    script.Status = ScriptStatus.Missing;
                }
                else
                {
                    if (string.IsNullOrEmpty(script.Sha256))
                    {
                        script.Status = ScriptStatus.UpToDate;
                    }
                    else
                    {
                        if (VerifyHash(localPath, script.Sha256))
                        {
                            script.Status = ScriptStatus.UpToDate;
                        }
                        else
                        {
                            script.Status = ScriptStatus.UpdateAvailable;
                        }
                    }
                }
            }
        }

        public bool IsAppUpdateAvailable(CodexManifest manifest)
        {
            if (manifest == null || string.IsNullOrEmpty(manifest.AppVersion)) return false;

            try
            {
                if (Version.TryParse(manifest.AppVersion, out Version remoteVer) &&
                    Version.TryParse(CURRENT_APP_VERSION, out Version localVer))
                {
                    return remoteVer > localVer;
                }
            }
            catch { }

            return !string.Equals(manifest.AppVersion.Trim(), CURRENT_APP_VERSION.Trim(), StringComparison.OrdinalIgnoreCase);
        }

        public async Task CheckAppUpdatePromptAsync()
        {
            try
            {
                CodexManifest manifest = await FetchManifestAsync();
                if (manifest == null)
                {
                    MessageBox.Show("Failed to connect to GitHub to check for updates.", "Update Check", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                if (IsAppUpdateAvailable(manifest))
                {
                    string changelogText = !string.IsNullOrEmpty(manifest.Changelog) ? $"\r\n\r\nChangelog:\r\n{manifest.Changelog}" : "";
                    DialogResult dr = MessageBox.Show(
                        $"A new version of Grimlite Li x CODEX is available!\r\n\r\nCurrent Version: v{CURRENT_APP_VERSION}\r\nLatest Version: v{manifest.AppVersion}{changelogText}\r\n\r\nWould you like to download and install this update automatically?",
                        "Update Available",
                        MessageBoxButtons.YesNo,
                        MessageBoxIcon.Information);

                    if (dr == DialogResult.Yes)
                    {
                        using (AppUpdateDialog dlg = new AppUpdateDialog(manifest))
                        {
                            dlg.ShowDialog();
                        }
                    }
                }
                else
                {
                    MessageBox.Show($"You are using the latest version of Grimlite Li x CODEX (v{CURRENT_APP_VERSION}).", "No Updates", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Could not check for updates: {ex.Message}", "Update Check", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public static void ApplyUpdateAndRestart(string newExePath)
        {
            try
            {
                string currentExePath = Application.ExecutablePath;
                string currentExeDir = Application.StartupPath;
                string exeName = Path.GetFileName(currentExePath);
                string newExeName = Path.GetFileName(newExePath);

                string batPath = Path.Combine(currentExeDir, "update_apply.bat");
                string batContent =
                    "@echo off\r\n" +
                    ":retry\r\n" +
                    "ping 127.0.0.1 -n 2 > nul\r\n" +
                    $"move /Y \"{newExeName}\" \"{exeName}\" >nul 2>&1\r\n" +
                    $"if exist \"{newExeName}\" goto retry\r\n" +
                    $"start \"\" \"{exeName}\"\r\n" +
                    "(goto) 2>nul & del \"%~f0\"\r\n";

                File.WriteAllText(batPath, batContent);

                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = $"/c \"{batPath}\"",
                    WorkingDirectory = currentExeDir,
                    CreateNoWindow = true,
                    UseShellExecute = false
                };

                Process.Start(psi);
                Environment.Exit(0);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to restart updater: " + ex.Message, "Update Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public async Task<SyncResult> SyncAllScriptsAsync(IProgress<(string message, int progress)> progressCallback = null)
        {
            SyncResult result = new SyncResult();

            if (CachedManifest == null)
            {
                await FetchManifestAsync();
            }

            if (CachedManifest == null || CachedManifest.Scripts == null || CachedManifest.Scripts.Count == 0)
            {
                result.Errors.Add("No scripts found in manifest or failed to load manifest.");
                return result;
            }

            EnsureBankFolderExists();

            result.Total = CachedManifest.Scripts.Count;
            int current = 0;

            foreach (var script in CachedManifest.Scripts)
            {
                current++;
                int pct = (int)((double)current / result.Total * 100);

                string safeName = Path.GetFileName(script.Name);
                progressCallback?.Report(($"Syncing {safeName}...", pct));

                bool success = await DownloadScriptAsync(script);
                if (success)
                {
                    result.Updated++;
                    script.Status = ScriptStatus.UpToDate;
                }
                else
                {
                    result.Failed++;
                    script.Status = ScriptStatus.Failed;
                    result.Errors.Add($"Failed to download or verify {safeName}");
                }
            }

            progressCallback?.Report(("Sync completed!", 100));
            return result;
        }

        public async Task<bool> DownloadScriptAsync(CodexScriptItem script)
        {
            if (script == null || string.IsNullOrEmpty(script.Name)) return false;

            EnsureBankFolderExists();

            string targetPath = GetScriptLocalPath(script);
            string tempPath = targetPath + ".tmp";

            string parentDir = Path.GetDirectoryName(targetPath);
            if (!string.IsNullOrEmpty(parentDir) && !Directory.Exists(parentDir))
            {
                Directory.CreateDirectory(parentDir);
            }

            string relUrlPath = GetScriptRelativePath(script).Replace('\\', '/');
            string downloadUrl = !string.IsNullOrEmpty(script.DownloadUrl)
                ? script.DownloadUrl
                : RAW_BASE_URL + Uri.EscapeUriString(relUrlPath);

            try
            {
                using (HttpClient client = CreateHttpClient())
                {
                    byte[] data = await client.GetByteArrayAsync(downloadUrl);

                    // Write to temporary file first
                    File.WriteAllBytes(tempPath, data);

                    // Verify SHA-256 hash if provided
                    if (!string.IsNullOrEmpty(script.Sha256))
                    {
                        if (!VerifyHash(tempPath, script.Sha256))
                        {
                            try { File.Delete(tempPath); } catch { }
                            return false;
                        }
                    }

                    // Move to destination, overwriting safely
                    if (File.Exists(targetPath))
                    {
                        File.Delete(targetPath);
                    }
                    File.Move(tempPath, targetPath);

                    return true;
                }
            }
            catch
            {
                try { if (File.Exists(tempPath)) File.Delete(tempPath); } catch { }
                return false;
            }
        }

        public bool VerifyHash(string filePath, string expectedHash)
        {
            if (string.IsNullOrEmpty(expectedHash)) return true;
            if (!File.Exists(filePath)) return false;

            // 1. Direct byte SHA256 match
            string directHash = ComputeSha256(filePath);
            if (string.Equals(directHash, expectedHash, StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }

            // 2. Resilient check for newline differences (LF vs CRLF) in text scripts/configs
            try
            {
                string text = File.ReadAllText(filePath);
                string lf = text.Replace("\r\n", "\n");
                if (string.Equals(ComputeStringSha256(lf), expectedHash, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }

                string crlf = lf.Replace("\n", "\r\n");
                if (string.Equals(ComputeStringSha256(crlf), expectedHash, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }
            catch { }

            return false;
        }

        public string ComputeStringSha256(string content)
        {
            if (content == null) return string.Empty;
            try
            {
                byte[] bytes = Encoding.UTF8.GetBytes(content);
                using (SHA256 sha = SHA256.Create())
                {
                    byte[] hash = sha.ComputeHash(bytes);
                    StringBuilder sb = new StringBuilder(hash.Length * 2);
                    foreach (byte b in hash)
                    {
                        sb.Append(b.ToString("X2"));
                    }
                    return sb.ToString();
                }
            }
            catch
            {
                return string.Empty;
            }
        }

        public string ComputeSha256(string filePath)
        {
            if (!File.Exists(filePath)) return string.Empty;

            try
            {
                using (FileStream stream = File.OpenRead(filePath))
                using (SHA256 sha = SHA256.Create())
                {
                    byte[] hash = sha.ComputeHash(stream);
                    StringBuilder sb = new StringBuilder(hash.Length * 2);
                    foreach (byte b in hash)
                    {
                        sb.Append(b.ToString("X2"));
                    }
                    return sb.ToString();
                }
            }
            catch
            {
                return string.Empty;
            }
        }

        private HttpClient CreateHttpClient()
        {
            HttpClient client = new HttpClient();
            client.Timeout = TimeSpan.FromSeconds(20);
            client.DefaultRequestHeaders.Add("User-Agent", "Grimlite-Codex-Client");
            client.DefaultRequestHeaders.CacheControl = new System.Net.Http.Headers.CacheControlHeaderValue
            {
                NoCache = true,
                NoStore = true,
                MustRevalidate = true
            };
            client.DefaultRequestHeaders.Pragma.Add(new System.Net.Http.Headers.NameValueHeaderValue("no-cache"));
            return client;
        }
    }
}





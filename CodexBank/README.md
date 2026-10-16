# Codex Script Bank

This folder contains official bot scripts synchronized directly by **Grimlite Li x CODEX**.

### How it works:
1. Scripts placed here are indexed in `manifest.json`.
2. When users click **"Sync Scripts"** in Grimoire, the client checks `manifest.json` against local files in `Bots/CodexBank/`.
3. Any new or updated scripts are automatically downloaded and verified via SHA-256.

### Adding a new script:
1. Place your `.gbot` file into this `CodexBank/` directory.
2. Calculate its SHA-256 hash:
   ```powershell
   Get-FileHash -Path .\YourScript.gbot -Algorithm SHA256
   ```
3. Add an entry to `manifest.json`:
   ```json
   {
     "name": "YourScript.gbot",
     "category": "Farming",
     "description": "Short description of what the bot does",
     "sha256": "YOUR_SHA256_HASH_HERE"
   }
   ```
4. Commit and push to GitHub. All users will see the update immediately!

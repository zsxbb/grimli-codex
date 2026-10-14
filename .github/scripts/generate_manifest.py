#!/usr/bin/env python3
import os
import json
import hashlib

def main():
    # Base paths relative to this script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_root = os.path.abspath(os.path.join(script_dir, "..", ".."))
    codex_dir = os.path.join(repo_root, "CodexBank")
    manifest_path = os.path.join(codex_dir, "manifest.json")

    if not os.path.isdir(codex_dir):
        print(f"Error: Directory not found: {codex_dir}")
        return

    # Preserve top-level app metadata from existing manifest if present
    app_version = "2.0"
    app_download_url = "https://github.com/zsxbb/grimli-codex/releases/latest/download/Grimoire.exe"
    app_release_url = "https://github.com/zsxbb/grimli-codex/releases/latest"
    changelog = "Grimlite Li x CODEX v2.0 - Official release with integrated Codex Script Bank & cloud sync."

    if os.path.isfile(manifest_path):
        try:
            with open(manifest_path, "r", encoding="utf-8") as f:
                old_data = json.load(f)
                app_version = old_data.get("app_version", app_version)
                app_download_url = old_data.get("app_download_url", app_download_url)
                app_release_url = old_data.get("app_release_url", app_release_url)
                changelog = old_data.get("changelog", changelog)
        except Exception as e:
            print(f"Warning: Could not read existing manifest ({e}), using default metadata.")

    custom_descriptions = {
        "AutoGrimDungeon.gbot": "Auto clear Grim Dungeon rooms and bosses.",
        "New World, New Opportunities.gbot": "Auto farm New World, New Opportunities quest.",
        "Eclipse/prep.gbot": "Gear & quest preparation for Midnight & Solstice.",
        "Eclipse/AscendEclipse.gbot": "Auto complete Ascend Eclipse dungeon.",
        "Eclipse/MidnightSun.gbot": "Midnight Sun raid team bot.",
        "Eclipse/SolsticeMoon.gbot": "Solstice Moon raid team bot.",
    }

    scripts = []

    for root, dirs, files in os.walk(codex_dir):
        # Sort files to ensure deterministic ordering
        for f in sorted(files):
            if f in ("manifest.json", "README.md", ".gitkeep") or f.startswith("."):
                continue

            full_path = os.path.join(root, f)
            rel_path = os.path.relpath(full_path, codex_dir).replace("\\", "/")

            # Read file bytes & compute LF-normalized SHA-256
            with open(full_path, "rb") as fp:
                raw_bytes = fp.read()

            try:
                text = raw_bytes.decode("utf-8")
                normalized = text.replace("\r\n", "\n").encode("utf-8")
            except UnicodeDecodeError:
                normalized = raw_bytes

            sha256 = hashlib.sha256(normalized).hexdigest().upper()

            # Determine category based on directory structure
            parts = rel_path.split("/")
            category = "General"
            if len(parts) == 1:
                if "Dungeon" in f:
                    category = "Dungeon"
                elif "New World" in f:
                    category = "Farming"
            else:
                top_folder = parts[0]
                if top_folder == "LR":
                    category = "Legion Revenant"
                elif top_folder == "Ultra Boss":
                    if "/Maid/" in rel_path:
                        category = "Ultra Boss (Maid)"
                    else:
                        category = "Ultra Boss"
                elif len(parts) > 2 and parts[1] == "Maid":
                    category = f"{top_folder} (Maid)"
                else:
                    category = top_folder

            # Determine description
            base_name, ext = os.path.splitext(f)
            if rel_path in custom_descriptions:
                desc = custom_descriptions[rel_path]
            elif ext == ".json":
                desc = f"Maid configuration for {base_name}."
            elif ext == ".txt":
                desc = f"Class setup notes for {base_name}."
            elif "Archmage" in rel_path:
                desc = f"Archmage quest bot: {base_name}."
            elif "Lae" in rel_path:
                desc = f"Lae Dark Knight quest bot: {base_name}."
            elif "Darkon" in rel_path:
                desc = f"Darkon quest farm bot: {base_name}."
            elif "Ultra Boss" in rel_path:
                boss_name = parts[1] if len(parts) > 2 else ""
                desc = f"Ultra Boss bot: {base_name} ({boss_name}).".replace(" ().", ".")
            else:
                desc = f"{base_name} bot script."

            scripts.append({
                "name": rel_path,
                "category": category,
                "description": desc,
                "sha256": sha256
            })

    # Sort scripts by category, then by name
    scripts.sort(key=lambda s: (s["category"].lower(), s["name"].lower()))

    manifest = {
        "app_version": app_version,
        "app_download_url": app_download_url,
        "app_release_url": app_release_url,
        "changelog": changelog,
        "scripts": scripts
    }

    with open(manifest_path, "w", encoding="utf-8") as fp:
        json.dump(manifest, fp, indent=2, ensure_ascii=False)
        fp.write("\n")

    print(f"Successfully generated CodexBank/manifest.json with {len(scripts)} scripts!")

if __name__ == "__main__":
    main()

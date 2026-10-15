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

    # Preserve top-level app metadata and per-script metadata from existing manifest
    app_version = "2.0.3"
    app_download_url = "https://github.com/zsxbb/grimli-codex/releases/latest/download/Grimoire.exe"
    app_release_url = "https://github.com/zsxbb/grimli-codex/releases/latest"
    changelog = "Grimlite Li x CODEX v2.0.3 - New Feature: Search name .gbot script on bot manager, Patch: Tools Cosmetics SWF Grabber Updated"
    existing_credits = {}
    existing_descriptions = {}

    if os.path.isfile(manifest_path):
        try:
            with open(manifest_path, "r", encoding="utf-8") as f:
                old_data = json.load(f)
                app_version = old_data.get("app_version", app_version)
                app_download_url = old_data.get("app_download_url", app_download_url)
                app_release_url = old_data.get("app_release_url", app_release_url)
                changelog = old_data.get("changelog", changelog)

                for item in old_data.get("scripts", []):
                    name = item.get("name")
                    if name:
                        # Support reading from credit or legacy author
                        credit_val = item.get("credit", item.get("author", ""))
                        if credit_val:
                            existing_credits[name] = credit_val
                        if item.get("description"):
                            existing_descriptions[name] = item.get("description")
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

            # Determine credit (preserve from manifest, no hardcoded name)
            credit = existing_credits.get(rel_path, "")

            # Determine description
            base_name, ext = os.path.splitext(f)
            parts = rel_path.split("/")
            if rel_path in existing_descriptions:
                desc = existing_descriptions[rel_path]
            elif rel_path in custom_descriptions:
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
                "credit": credit,
                "description": desc,
                "sha256": sha256
            })

    # Sort scripts by relative path name
    scripts.sort(key=lambda s: s["name"].lower())

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



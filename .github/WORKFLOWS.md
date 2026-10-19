# Panduan Otomatisasi GitHub (.github)

Folder `.github` ini berisi seluruh konfigurasi otomatisasi CI/CD (**GitHub Actions**) dan skrip pendukung untuk repository **Grimlite Li x CODEX**.

---

## 📁 Struktur Direktori

```
.github/
├── WORKFLOWS.md                   # Dokumentasi ini
├── workflows/
│   ├── release.yml                # Otomatisasi Build & Publikasi Release Grimoire.exe
│   └── generate-manifest.yml      # Otomatisasi pembuatan katalog CodexBank/manifest.json
└── scripts/
    └── generate_manifest.py       # Skrip Python pembuat metadata bot CodexBank
```

---

## 🚀 1. Otomatisasi Build & Rilis Versi Baru (`release.yml`)

Workflow ini berjalan di server GitHub pada lingkungan **Windows** (`windows-latest`). Workflow ini meng-compile file solusi `Project Grimlite.sln` ke konfigurasi **Release x86** dan secara otomatis mengunggah file eksekusi mandiri `Grimoire.exe` ke halaman **GitHub Releases**.

### Cara Merilis Versi Baru dari Lokal

Gunakan helper script [`bump-version.ps1`](../bump-version.ps1) yang ada di root repository. Anda cukup menjalankan satu baris perintah di PowerShell:

#### Opsi A: Sekali Jalan (Update Versi + Commit + Tag + Auto Build)
```powershell
.\bump-version.ps1 2.0.3 -Changelog "Perbaikan packet spammer dan penambahan bot baru" -Push
```
*Ganti `2.0.3` dengan nomor versi baru Anda.*

#### Opsi B: Review Perubahan Dulu Sebelum Push
Jika Anda ingin memeriksa perubahan secara lokal sebelum dikirim ke GitHub:
1. Jalankan script tanpa flag `-Push`:
   ```powershell
   .\bump-version.ps1 2.0.3 -Changelog "Perbaikan fitur"
   ```
2. Periksa git status:
   ```powershell
   git status
   git log -1
   ```
3. Jika sudah sesuai, kirim ke GitHub:
   ```powershell
   git push origin main
   git push origin v2.0.3
   ```

---

### File Apa Saja yang Otomatis Diperbarui oleh `bump-version.ps1`?

Script tersebut menyinkronkan 4 file sekaligus agar versi aplikasi konsisten:
1. **`Properties/AssemblyInfo.cs`**:
   - Memperbarui `[assembly: AssemblyVersion("X.X.X.0")]`
   - Memperbarui `[assembly: AssemblyFileVersion("X.X.X.0")]`
2. **`Grimoire/Tools/CodexBankManager.cs`**:
   - Memperbarui konstanta `CURRENT_APP_VERSION = "X.X.X";`
3. **`CodexBank/manifest.json`**:
   - Memperbarui `"app_version": "X.X.X"`
   - Memperbarui `"changelog": "Grimlite Li x CODEX vX.X.X - <Catatan>"`
4. **`.github/scripts/generate_manifest.py`**:
   - Memperbarui nilai fallback default versi.

---

### Alur yang Terjadi di GitHub Actions (`release.yml`):
1. **Deteksi Tag**: Aktif setiap kali ada push tag berawalan huruf `v` (contoh: `v2.0.3`).
2. **Persiapan Mesin**: Membuka runner `windows-latest` yang sudah dilengkapi .NET Framework 4.7.2 dan Visual Studio MSBuild.
3. **Restore & Build**:
   - `nuget restore "Project Grimlite.sln"`
   - `msbuild "Project Grimlite.sln" /p:Configuration=Release /p:Platform=x86 /m`
   - Berkat **Costura.Fody**, semua dependensi DLL (termasuk Flash ActiveX dan pustaka internal) otomatis dibundel menyatu ke dalam file tunggal `Grimoire.exe`.
4. **Publikasi Release**:
   - Menggunakan action `softprops/action-gh-release@v2`.
   - Mengunggah file `bin/x86/Release/Grimoire.exe` ke rilis GitHub baru sesuai nama tag.
   - Link download rilis otomatis selalu tersedia di:
     `https://github.com/zsxbb/grimli-codex/releases/latest/download/Grimoire.exe`

---

## 📦 2. Otomatisasi Katalog Script Bank (`generate-manifest.yml`)

Workflow ini bertugas memperbarui katalog script bot di **CodexBank** secara otomatis tanpa perlu mengedit `manifest.json` secara manual:

- **Trigger**: Aktif otomatis saat Anda melakukan `push` file bot baru (misal `.gbot`, `.json`, `.txt`) ke folder `CodexBank/`.
- **Eksekusi**: Menjalankan `.github/scripts/generate_manifest.py` di runner GitHub untuk memindai seluruh folder script.
- **Commit**: Otomatis meng-commit kembali file `CodexBank/manifest.json` yang telah diperbarui ke branch `main` dengan pesan `chore(codexbank): auto-generate manifest.json [skip ci]`.

---

### ✨ Fitur Pintar Skrip Generator (`generate_manifest.py`)

Skrip generator dirancang agar penambahan script bot sangat cepat dan bebas dari kesalahan manusia (*human error*):

1. **Auto-Extract Author dari `.gbot`**:
   - Jika file `.gbot` memiliki field `"Author"` di dalamnya (diisi saat membuat bot di Grimoire), generator akan **otomatis mengambil nama tersebut sebagai `credit`**.
2. **Preserve Existing Credits**:
   - Nilai `credit` yang sudah ada di `manifest.json` akan selalu dipertahankan.
3. **Fallback Per Folder**:
   - Jika field Author kosong, skrip memiliki aturan fallback otomatis berdasarkan folder (contoh: folder `Sea Voice` otomatis mendapat credit `"zsxbb"`).
4. **LF-Normalized SHA-256 Hash**:
   - Menghitung hash SHA-256 dengan normalisasi newline (`\r\n` -> `\n`) sehingga hash selalu konsisten antara Windows dan Linux, serta cocok 100% dengan fungsi verifikasi hash di `CodexBankManager.cs`.
5. **Auto Description**:
   - Membuat deskripsi quest bot otomatis berdasarkan nama file dan kategori (seperti Archmage, Darkon, Lae, Sea Voice, Ultra Boss, Maid config, dll).

---

### 📝 Alur Praktis Menambahkan Script Bot Baru:

1. **Simpan Bot**: Letakkan file `.gbot` baru ke dalam subfolder yang sesuai di `CodexBank/` (misal: `CodexBank/Sea Voice/NamaBot.gbot`).
2. **Pilih Salah Satu Metode Sinkronisasi**:
   - **Metode A (Lokal - Rekomendasi sebelum push)**:
     ```powershell
     python .github/scripts/generate_manifest.py
     ```
     `manifest.json` akan terisi seketika. Lalu commit dan push seperti biasa:
     ```powershell
     git add CodexBank/
     git commit -m "feat(codex): add new bot scripts"
     git push origin main
     ```
   - **Metode B (Otomatis via Cloud)**:
     Cukup commit & push file `.gbot` baru ke GitHub:
     ```powershell
     git add "CodexBank/Sea Voice/NamaBot.gbot"
     git commit -m "feat(codex): add new Sea Voice bot"
     git push origin main
     ```
     GitHub Actions (`generate-manifest.yml`) akan otomatis membuatkan entri `manifest.json` untuk Anda.

> [!NOTE]
> **Apakah perlu compile / build ulang `Grimoire.exe` saat menambah bot baru?**
> **TIDAK PERLU.** Sistem Codex Bank bekerja secara dinamis melalui sinkronisasi cloud HTTPS langsung dari repository GitHub. Begitu file bot dan `manifest.json` ter-push ke branch `main`, semua pengguna `Grimoire.exe` langsung dapat melihat dan mengunduh bot baru melalui tombol **"Sync Scripts"**.

---

## 💻 3. Build Lokal vs Build Cloud (GitHub)

Apakah masih bisa build di komputer lokal? **Tentu saja, keduanya saling melengkapi.**

| Kategori | 💻 Build Lokal (Komputer Anda) | ☁️ Build Cloud (GitHub Actions) |
| :--- | :--- | :--- |
| **Kapan Dipakai** | Saat sedang coding, uji coba fitur baru, debugging, atau testing bot. | Saat fitur sudah selesai dan siap dirilis ke publik. |
| **Kecepatan** | Instan (hitungan detik di PC Anda). | ~1-2 menit di server virtual GitHub. |
| **Tujuan** | Menghasilkan `Grimoire.exe` lokal untuk dicoba sendiri sebelum commit. | Menghasilkan `Grimoire.exe` bersih yang otomatis di-upload ke **GitHub Releases**. |
| **Cara Menjalankan**| Jalankan `.\build.ps1` atau lewat Visual Studio (`F5` / `Ctrl+Shift+B`). | Jalankan `.\bump-version.ps1 <versi> -Push` atau buat tag `v*`. |

### Cara Build di Komputer Lokal:
1. **Via Terminal (PowerShell)**:
   ```powershell
   .\build.ps1 -Configuration Release
   ```
   File hasil kompilasi akan langsung berada di:
   `bin\x86\Release\Grimoire.exe`
2. **Via Visual Studio**:
   Buka `Project Grimlite.sln`, pilih target `Release` dan `x86`, lalu tekan `Ctrl + Shift + B`.

### Alur Rekomendasi Sehari-hari:
1. **Coding & Tes Lokal**: Ubah kode -> jalankan `.\build.ps1` -> coba jalankan `bin\x86\Release\Grimoire.exe` di PC Anda.
2. **Rilis ke Publik**: Setelah yakin semuanya stabil tanpa bug -> jalankan `.\bump-version.ps1 2.0.3 -Push`. Server GitHub yang akan meng-compile versi rilis resmi dan mengunggahnya ke GitHub Releases.

---

## 🛠️ Tips & Catatan Tambahan

- **Build Manual via Web**: Anda juga dapat memicu workflow `release.yml` secara manual melalui tab **Actions** di GitHub repository dengan menekan tombol **Run workflow** (fitur `workflow_dispatch`).
- **File Output**: Hanya file mandiri `Grimoire.exe` yang dirilis, tidak membutuhkan file zip terpisah sehingga mempermudah pengguna akhir dan sistem auto-update di dalam game.

---

## 📋 Riwayat Versi & Changelog

### v2.0.5
* **New Feature (Skill Moments)**: Active Rules checkbox selection (aktifkan/nonaktifkan rule secara selektif dengan centang tanpa harus menghapus).
* **New Feature (Loop Taunt)**: Pengganti Loop Aura dengan sistem built-in Taunt 1 & Taunt 2 (siklus rotasi 5 detik, opening manual untuk Taunt 1, anti-stop watchdog 10.5 detik).
* **Note**: Update: CODEX features: Skill Moment Choose Rules, Loop Taunt.

### v2.0.3
* **New Feature**: Search name .gbot script on bot manager
* **Patch**: Tools Cosmetics SWF Grabber Updated



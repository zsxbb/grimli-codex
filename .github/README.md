# Panduan Otomatisasi GitHub (.github)

Folder `.github` ini berisi seluruh konfigurasi otomatisasi CI/CD (**GitHub Actions**) dan skrip pendukung untuk repository **Grimlite Li x CODEX**.

---

## 📁 Struktur Direktori

```
.github/
├── README.md                      # Dokumentasi ini
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

Workflow ini bertugas memperbarui katalog script bot di **CodexBank**:
- **Trigger**: Aktif otomatis saat Anda melakukan `push` file bot baru (misal `.gbot`) ke folder `CodexBank/`.
- **Eksekusi**: Menjalankan `.github/scripts/generate_manifest.py` untuk memindai hash, nama file, ukuran, dan metadata bot.
- **Commit**: Otomatis meng-commit kembali file `CodexBank/manifest.json` yang telah diperbarui ke branch `main`.

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


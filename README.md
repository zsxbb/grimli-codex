<div align="center">

# Grimlite Li x CODEX v2.0

**Advanced Client Architecture, Network Packet Engine, Cloud Script Bank & Automation Suite for AdventureQuest Worlds**

[![Release](https://img.shields.io/badge/Release-v2.0_Stable-brightgreen?style=for-the-badge&logo=github)](https://github.com/zsxbb/grimli-codex/releases/latest)
[![Download Latest](https://img.shields.io/badge/Download-Full_Package_(.zip)-0078D6?style=for-the-badge&logo=windows)](https://github.com/zsxbb/grimli-codex/releases/latest)

<br />

[![.NET Framework](https://img.shields.io/badge/.NET_Framework-4.7.2-512BD4?style=flat-square&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![C#](https://img.shields.io/badge/C%23-7.3-239120?style=flat-square&logo=csharp&logoColor=white)](https://docs.microsoft.com/dotnet/csharp/)
[![Platform](https://img.shields.io/badge/Platform-Windows_x86-0078D6?style=flat-square&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Flash Engine](https://img.shields.io/badge/Flash_ActiveX-Cleanflash-FF0000?style=flat-square&logo=adobe-flash&logoColor=white)](https://get.adobe.com/flashplayer)
[![Audio Codec](https://img.shields.io/badge/Audio_Codec-Opus_Stereo_48kHz-blueviolet?style=flat-square)](https://opus-codec.org/)
[![Cloud Sync](https://img.shields.io/badge/Script_Bank-75+_Cloud_Bots-orange?style=flat-square)]()
[![In-App Updater](https://img.shields.io/badge/Auto_Updater-Integrated-blue?style=flat-square)]()

<br />

</div>

**Grimlite Li x CODEX v2.0** adalah platform modifikasi klien, otomasi tingkat lanjut, dan analisis protokol jaringan generasi baru untuk **AdventureQuest Worlds (AQW)**. Dikembangkan di atas arsitektur .NET Framework 4.7.2 (C# / Windows Forms) dan Flash ActiveX runtime, rilis v2.0 menghadirkan integrasi **Codex Script Bank** (sinkronisasi cloud 75+ bot langsung dari GitHub), **In-App Auto-Updater** (pembaruan otomatis aplikasi tanpa perlu download manual), suite utilitas eksklusif **CODEX Suite**, sistem audio **Codex Voice Chat**, serta otomasi tempur **Maid Remake** yang cepat dan stabil.

---

## 📥 Panduan Instalasi & Download

### Pengguna Baru (Install Pertama Kali):
1. Unduh paket rilis lengkap terbaru melalui tombol di atas atau halaman **[Releases](https://github.com/zsxbb/grimli-codex/releases/latest)**:
   👉 **`Grimlite-Li-x-CODEX-Full-Package.zip`**
2. Klik kanan file `.zip` tersebut > pilih **Extract All** ke folder mana pun di laptop Anda.
3. Jalankan **`Grimoire.exe`**.

### Pengguna Lama (Pembaruan Otomatis):
- Anda **tidak perlu mengunduh ulang file zip** secara manual.
- Cukup buka aplikasi Grimoire > klik menu **About** > pilih **Update App**.
- Aplikasi akan otomatis mendownload pembaruan di latar belakang dan merestart dirinya sendiri ke versi terbaru!

---

## 🌟 Fitur Unggulan v2.0

### 1. Codex Script Bank (Cloud Sync)
Pustaka skrip resmi terintegrasi langsung dengan GitHub repository:
- **75+ Skrip & Konfigurasi Siap Pakai:**
  - **Archmage:** Alur quest lengkap (Part 1 s/d 9 & Unbound Thread).
  - **Darkon:** Farm lengkap material Darkon (Melody, Remnant, Teeth, Banana, Suki Prestige, dll.).
  - **Legion Revenant:** Fealty 1, Fealty 2, dan Fealty 3.
  - **Lae:** Seluruh quest Dark Knight.
  - **Ultra Boss:** Drakath, Dark Carnax, Ultra Dage, Darkon, Drago, Nulgath, TimeInn, Tyndarius.
  - **Eclipse Dungeon:** Ascend Eclipse, Midnight Sun, Solstice Moon, serta konfigurasi Maid support (AP, LOO, LR, SC, Follower).
  - **Class Combos & Rep:** Arcana Invoker, ArchMage, TimeKeeper, Alchemy REP, IceStormArena, dll.
- **Isolasi Folder Aman:** Seluruh bot cloud disimpan rapi di `Bots/CodexBank/`, memastikan skrip pribadi Anda di folder utama `Bots/` tidak akan pernah tertimpa atau terhapus.
- **Struktur Kategori Multi-Folder:** Mendukung subfolder bertingkat yang otomatis muncul rapi di TreeView **Bot Manager**.
- **Otomatisasi Penuh (GitHub Actions):** Setiap penambahan bot di repository langsung disinkronkan ke seluruh pengguna secara instan tanpa limit kuota.

### 2. In-App Auto-Updater
- **Pengecekan Live Anti-Cache:** Membaca status rilis terbaru secara instan langsung dari server CDN GitHub.
- **Background Downloader:** Mengunduh biner baru dengan visualisasi progress bar (MB & persentase).
- **Seamless Self-Restart:** Mengganti executable lama dan menjalankan versi baru secara otomatis tanpa memerlukan software installer pihak ketiga.

### 3. Menu About Terpadu
Navigasi rapi dengan 3 opsi terpadu:
- **App Detail:** Membuka informasi rilis, kredit pengembang, dan status runtime.
- **Update App:** Memeriksa dan menginstal pembaruan aplikasi otomatis.
- **Sync Update Script:** Membuka browser Codex Script Bank untuk memperbarui pustaka bot Anda.

---

## 🛠️ CODEX Suite & Utilitas Lanjutan

### A. Voice Chat Terintegrasi (CodexForm)
Sistem komunikasi suara *real-time* berlatensi rendah tanpa aplikasi pihak ketiga:
- **Audio Controls:** Slider sensitivitas Mic Boost (hingga 300%) dan Volume Output (hingga 200%).
- **Live VU Meter & VAD:** Deteksi aktivitas suara otomatis dengan visualisasi status berbicara.
- **Kompresi Opus 48kHz:** Kualitas audio stereo jernih dengan konsumsi bandwidth minimal.
- **Room Isolation:** Komunikasi suara otomatis diisolasi hanya untuk pemain dalam kombinasi `Server`, `Map`, dan `Cell` yang sama.

### B. Skill Moment (CodexSkillForm)
Respon mekanik Ultra Boss otomatis berbasis pemicu (*event-driven*):
- **Trigger by Message:** Deteksi teks peringatan merah monster/boss dengan opsi target kemunculan (1st Match, 2nd Match, All).
- **Trigger by HP:** Ambang batas persentase atau nilai absolut HP monster.
- **Aksi Cepat:** Eksekusi otomatis Skill 1 s/d 5 (Taunt / Scroll of Enrage, Heal, Shield) dengan jeda milidetik terkalibrasi.

### C. Loop Aura / Enrage (CodexEnrageForm)
Otomasi eksekusi skill berdasarkan pemantauan paket aura SmartFoxServer (`aura+` / `aura-`):
- Menghitung durasi aktif aura secara akurat (contoh: "Focus").
- Eksekusi skill saat mencapai batas waktu dengan validasi cooldown aman (`Player.SkillAvailable`).
- Auto-reset siklus saat target berganti atau mati.

### D. Bypass Map (BypassMapForm)
Membuka seluruh gerbang peta dan alur cerita quest secara instan:
- Modifikasi objek client-side `strQuests` untuk melewati syarat progres alur cerita.
- Menampilkan monster dan ruangan tersembunyi tanpa merusak data server.

### E. Quest & Shop Pinner
- **Quest Pinner:** Menyematkan quest Ultra Boss mingguan dan harian dengan fitur *Load*, *Accept*, dan *Auto Turn-In* otomatis berjarak aman.
- **Shop Pinner:** Membuka toko tanpa harus berjalan manual ke lokasi dengan prosedur *Safe Travel & Load*.

---

## ⚡ Modern Packet Engine & Network Toolkit

Intersepsi, injeksi, dan analisis paket jaringan langsung via Flash ActionScript Bridge tanpa ketergantungan proxy TCP lokal yang rentan *packet-loss*:
- **Packet Tamperer:** Intersepsi paket masuk/keluar dengan penyaringan teks dan *Auto-Strip Prefix*.
- **Packet Logger:** Pencatatan log transaksi paket SFS secara *real-time*.
- **Packet Spammer:** Pengiriman paket berulang dengan dukungan token dinamis (`{ROOM_ID}`, `{MAP}`, `{PLAYERNAME}`).
- **Safe Payload Handler:** Penanganan aman paket string XT (`%xt%`), XML, dan JSON SFS tanpa risiko crash.

---

## 🤖 Core Bot Engine & Maid Remake

- **Eksekusi Skrip (.gbot):** Otomasi penuh alur quest, pertempuran, penyerangan monster, drop item, istirahat, dan jeda kustom.
- **Auto-Follow Master:** Mengikuti pergerakan pemain target secara otomatis antar ruangan dan sel (`CellJumperHandler`, `JoinMapHandler`, `CopyWalkHandler`).
- **Party Chat Command Automation:** Merespons perintah chat party `/p` (`.join`, `.acc`, `.turnin`, `.target`, `.start`, `.stop`).
- **Ultra Boss Mechanics Handler:** Penanganan logika mekanik khusus (*Ultra Speaker, Ultra Gramiel, Ultra Warden, Dark Carnax, Malgor*, dll.) mencakup balancing HP monster dan pemecahan perisai.
- **Anti-Counter Attack Defense:** Deteksi status serangan balasan monster untuk mencegah kematian instan saat monster berada dalam kondisi *counter*.

---

## 📖 Dokumentasi Teknis Tambahan
- **[Panduan Optimasi & Efisiensi Performa](docs/Performance_Guide.md):** Analisis threading Flash ActiveX, alokasi CPU multi-core, dan akselerasi GPU.

---

## ⌨️ Daftar Pintasan Keyboard

| Kombinasi Tombol | Fungsi Operasional |
| :--- | :--- |
| **Ctrl + C** | Menyalin perintah bot yang dipilih (format serialisasi `.gbot`) |
| **Ctrl + V** | Menempelkan (*paste*) baris instruksi `.gbot` dari clipboard |
| **Ctrl + S** | Menyimpan skrip bot aktif ke file konfigurasi `.gbot` |
| **Ctrl + Panah Atas / Bawah** | Memindahkan urutan prioritas baris instruksi yang dipilih |
| **Ctrl + [Add Command]** | Menyisipkan perintah baru tepat di atas indeks baris yang dipilih |
| **Alt + [Add Command]** | Mengalihkan mode eksekusi perintah (contoh: *Normal Accept* ke *Ghost Accept*) |
| **Klik Ganda (Perintah Bot)** | Membuka jendela dialog editor detail instruksi |
| **Klik Ganda (Daftar Shop)** | Menjalankan prosedur pembukaan shop di Shop Pinner |
| **Klik Ganda (Log Paket)** | Menyalin string payload ke kolom input Packet Tamperer |

---

## 💻 Kompilasi dari Source Code

### Prasyarat:
- Windows 7 / 8 / 10 / 11 (32-bit & 64-bit)
- .NET Framework 4.7.2 Developer Pack
- Visual Studio 2022 (atau Build Tools 2022)

### Menggunakan Skrip Otomatis (Direkomendasikan):
```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1
```

Biner hasil kompilasi akan tersedia di:
```text
bin\x86\Release\Grimoire.exe
```

---

## 🌐 Deployment Signaling Server (Voice Chat)

Direktori [signaling-server/](file:///c:/Users/HP%20Elitebook%20X360/antigravity/aqw-grimcodex/signaling-server/) memuat layanan relai berbasis Node.js WebSocket untuk distribusi sinyal audio yang siap diintegrasikan di balik **Cloudflare Proxy (WSS)**:

```bash
cd signaling-server
npm install
npm install -g pm2
pm2 start server.js --name "grimcodex-voice"
pm2 save
pm2 startup
```

---

## ⚖️ Batasan Tanggung Jawab (Disclaimer)
*Perangkat lunak ini dikembangkan semata-mata untuk tujuan edukasi, riset protokol jaringan, dan studi arsitektur rekayasa perangkat lunak non-komersial. Pengembang tidak bertanggung jawab atas penyalahgunaan aplikasi yang bertentangan dengan ketentuan layanan pihak terkait.*

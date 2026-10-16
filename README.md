<div align="center">

# GrimCodex

**Advanced Client Architecture, Network Packet Engine & Automation Suite for AdventureQuest Worlds**

[![.NET Framework](https://img.shields.io/badge/.NET_Framework-4.7.2-512BD4?style=flat-square&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![C#](https://img.shields.io/badge/C%23-7.3-239120?style=flat-square&logo=csharp&logoColor=white)](https://docs.microsoft.com/dotnet/csharp/)
[![Platform](https://img.shields.io/badge/Platform-Windows_x86-0078D6?style=flat-square&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Flash Engine](https://img.shields.io/badge/Flash_ActiveX-Cleanflash-FF0000?style=flat-square&logo=adobe-flash&logoColor=white)](https://get.adobe.com/flashplayer)
[![Audio Codec](https://img.shields.io/badge/Audio_Codec-Opus_Stereo_48kHz-blueviolet?style=flat-square)](https://opus-codec.org/)
[![Signaling Server](https://img.shields.io/badge/Signaling_Server-Node.js_WebSocket-339933?style=flat-square&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![Build Status](https://img.shields.io/badge/Build-Stable-brightgreen?style=flat-square)]()
[![License](https://img.shields.io/badge/License-Research_&_Educational-lightgrey?style=flat-square)]()

<br />

</div>

GrimCodex adalah platform modifikasi klien, otomasi tingkat lanjut, dan analisis protokol jaringan untuk **AdventureQuest Worlds (AQW)**. Dikembangkan di atas arsitektur .NET Framework 4.7.2 (C# / Windows Forms) dan Flash ActiveX runtime, proyek ini mengintegrasikan rangkaian utilitas eksklusif **CODEX Suite**, sistem komunikasi suara berlatensi rendah (**Codex Voice Chat**), sistem otomasi pertempuran **Maid Remake**, serta arsitektur **Modern Packet Engine** yang cepat dan stabil.

---

## 1. CODEX Suite (Menu Terintegrasi CODEX)

Menu terintegrasi yang dirancang khusus untuk utilitas tingkat lanjut, pertempuran Ultra Boss, dan optimalisasi navigasi:

### A. Voice Chat (CodexForm)
Sistem komunikasi suara *real-time* berlatensi rendah yang terintegrasi secara *native* di dalam aplikasi tanpa memerlukan aplikasi pihak ketiga:
- **Device Selector:** Pemilihan perangkat input mikrofon secara dinamis dari daftar perangkat audio sistem.
- **Audio Gain Controls:**
  - *Mic Boost Slider (Input):* Penguatan sensitivitas input mikrofon dari 0% hingga 300%.
  - *Voice Volume Slider (Output):* Penguatan volume output suara seluruh partisipan dari 0% hingga 200%.
- **Audio State Toggles:** Opsi aktivasi *Enable Voice*, *Mute* (senyapkan mikrofon), *Deafen* (senyapkan suara masuk), dan *Loopback* (uji dengar mandiri).
- **Live VU Meter:** Visualisasi intensitas amplitudo input mikrofon secara langsung (0% – 100%).
- **Peer List & Voice Activity Detection (VAD):** Daftar pemain aktif dalam satu ruangan/sel dengan visualisasi kustom (titik hijau terang `#57F287` saat bersuara, titik abu-abu `#64646E` saat senyap).
- **Arsitektur Jaringan Audio:**
  - Kompresi audio **Opus Codec** (*Concentus*) Stereo 48kHz berlatensi rendah.
  - Sinyal kehadiran via WebSocket (WSS terenkripsi Cloudflare port 443) atau TCP.
  - Transmisi audio P2P UDP dengan deteksi Symmetric NAT dan *fallback relay* VPS UDP.
  - Protokol darurat (*emergency fallback*) via chat in-game terenkripsi *Symmetric XOR* (`GrimCodexVoice2026` / `CodexVoiceShield2026`).
  - *Strict Room Isolation:* Hanya meneruskan data audio antar pemain pada kombinasi `Server`, `Map`, dan `Cell` yang sama.

### B. Skill Moment (CodexSkillForm)
Sistem respons mekanik Ultra Boss otomatis berbasis pemicu (*event-driven rule engine*):
- **Trigger by Message:** Memantau pesan peringatan merah (*warning/red message*) monster/boss pada paket game dengan opsi pemilihan *occurrence* (1st Match, 2nd Match, atau All Matches).
- **Trigger by HP Monster:** Memantau ambang batas HP monster, baik berbasis persentase (`Percentage (%)` contoh: 70, 50, 30) maupun nilai absolut HP monster.
- **Eksekusi Aksi Skill:** Mengeksekusi skill pilihan (Skill 1 s/d 5, seperti Taunt / Scroll of Enrage, Heal, atau Skill defensif) dengan jeda waktu terkalibrasi (*Delay in seconds*).
- **Konfigurasi Aturan:** Mendukung penambahan, penghapusan, serta penyimpanan (*Save*) dan pemuatan (*Load*) aturan konfigurasi dalam format JSON (`Config/*.json`).

### C. Loop Aura / Loop Enrage (CodexEnrageForm)
Modul otomasi eksekusi skill berbasis durasi aura target:
- **Aura Packet Sniffing:** Memantau paket SmartFoxServer secara real-time (`cmd == "aura+"` dan `cmd == "aura-"`) untuk mendeteksi keberadaan aura tertentu (contoh: "Focus").
- **Presisi Waktu Pemicu:** Menghitung waktu aktif aura secara akurat dan mengeksekusi skill yang dipilih (Skill 1 s/d 5, default Skill 5 / Scroll of Enrage) saat durasi mencapai ambang batas (*Trigger Seconds*).
- **Mekanisme Eksekusi Aman:** Menunggu kesiapan cooldown skill (`Player.SkillAvailable`) dan memvalidasi keberhasilan eksekusi sebelum siklus berikutnya.
- **Auto-Reset:** Melakukan reset otomatis status siklus saat target mati, berganti target, atau pemain mati.

### D. Bypass Map (BypassMapForm)
Modul pembuka akses peta dan alur cerita secara instan:
- **Client-Side Quest String Bypass:** Memodifikasi objek Flash client `world.myAvatar.objData.strQuests` (indeks 1 sampai 7) menjadi deretan karakter valid `'Z'`.
- **Storylines Unlocked:** Membuka seluruh gerbang peta dan ruangan yang sebelumnya terkunci oleh syarat quest cerita (*storyline progression*).
- **Monster Visibility:** Menampilkan seluruh monster yang sebelumnya tersembunyi karena batasan alur cerita.
- **Keamanan:** Bersifat *client-side only*; status progres akun asli dapat dipulihkan cukup dengan melakukan re-login.

### E. Quest Pinner (QuestPinnerForm)
Modul penyematan dan otomasi penyelesaian quest:
- **Penyematan Quest Kustom:** Menambahkan Quest ID dengan nama deskriptif sesuai kebutuhan pemain.
- **Preset Bawaan Terintegrasi:** Dilengkapi daftar quest Ultra Boss Mingguan (*Ultra Drakath, Ultra Engineer, Ultra Warden, Ultra Ezrajal, Ultra Dage, Ultra Nulgath, Ultra Boss Weekly*), quest harian (*Daily*), dan *Crafted: Scrolls of Enrage (2330)*.
- **Load & Accept Terpadu:**
  - *Load Selected:* Memuat paket data quest dari server untuk seluruh quest yang dipilih.
  - *Accept Selected:* Memuat lalu menerima quest yang dipilih secara berurutan dengan jeda aman 700ms.
- **Auto Turn In Selected:** Menjalankan timer latar belakang (interval 1500ms) untuk memeriksa status penyelesaian quest (`Player.Quests.CanComplete`) dan otomatis menyerahkan quest (`Player.Quests.Complete`) saat syarat terpenuhi.
- **Manajemen Daftar:** Pengurutan prioritas urutan (Up / Down) serta persistensi otomatis ke `PinnedQuests.json`.

### F. Shop Pinner (ShopPinnerForm)
Modul penyematan dan pembukaan toko secara terotomasi dan aman:
- **Penyematan Toko:** Menyimpan konfigurasi Shop ID, Target Map, dan Nama Toko.
- **Preset Default:** Tersedia preset siap pakai untuk Alchemy Academy (*Jera, Uruz, Gebo, Febu*) dan Tercessuinotlim (*Swindle Merge*).
- **Prosedur Pembukaan Aman (Safe Travel & Load):**
  1. Memverifikasi status login pemain.
  2. Keluar dari status pertempuran (*Exit Combat*) jika karakter sedang bertarung.
  3. Berpindah peta secara otomatis (`Player.JoinMap`) jika karakter belum berada di lokasi toko, lalu menunggu hingga peta selesai dimuat.
  4. Menunggu cooldown aksi game (`LockActions.LoadShop` - 3 detik).
  5. Membuka jendela toko secara aman melalui Flash engine (`Shop.Load(shop.Id)`).
- **Aksi Cepat:** Klik ganda (*double click*) pada daftar langsung memicu prosedur pembukaan toko, disertai pengurutan prioritas (Up / Down) dan penyimpanan ke `PinnedShops.json`.

---

## 2. Modern Packet Engine & Network Toolkit

Intersepsi, injeksi, dan analisis paket jaringan tingkat lanjut tanpa ketergantungan pada proxy TCP lokal yang rentan *packet-loss*:

### Direct Flash ActionScript Bridge
- Berkomunikasi langsung dengan Flash client via `ExternalInterface` (`CallHandler`), menangkap seluruh event jaringan SmartFoxServer (`SFSEvent.onDebugMessage` dan `SFSEvent.onExtensionResponse`).
- **Otomatisasi Debug SFS:** Mengaktifkan `sfc.debug = true` dan `world.sfc.debug = true` pada Flash engine saat pertama kali terhubung ke server (`OnConnection` / `firstJoin`) serta saat form jaringan diakses.
- **Dukungan Protokol Lengkap:** Menangkap paket respon server reguler (`packetFromServer`) dan paket ekstensi (*pext*) seperti sinkronisasi monster, loot item, aura, dan pergerakan pemain.

### Network Toolkit (Menu Packets)
- **Packet Tamperer (PacketTamperer):**
  - Opsi intersepsi fleksibel: *Capture from server*, *Capture from client*, serta penyaringan teks (*Filter by text*).
  - *Asynchronous UI Dispatcher:* Menggunakan `BeginInvoke` aman (`IsHandleCreated && !IsDisposed`) sehingga UI tetap responsif tanpa *freeze* meski menerima ratusan paket per detik saat pertempuran bos.
  - *Quick Transfer & Auto-Strip Prefix:* Klik ganda pada log paket langsung menyalin string ke input pengiriman dan otomatis menghapus awalan `"From server: "` atau `"From client: "`.
- **Packet Sniffer / Logger (PacketLogger):** Pencatatan log paket masuk dan keluar secara *real-time*.
- **Packet Spammer (PacketSpammer):** Pengiriman paket berulang dengan jeda milidetik terukur dan dukungan token dinamis (`{ROOM_ID}`, `{MAP}`, `{PLAYERNAME}`).
- **Packet Interceptor (PacketInterceptor):** Pengalihan atau manipulasi string paket sebelum diteruskan ke server atau klien.
- **Safe Payload & Decompression Handler:**
  - Penanganan aman paket string XT (`%xt%`), XML, dan JSON SFS tanpa crash.
  - Mekanisme dekompresi otomatis Base64 + GZip (`DocConvert.Unzip`) sebagai penanganan sekunder.
  - Antrean pemrosesan paralel berkecepatan tinggi pada `CaptureProxy`.

---

## 3. Sistem Otomasi Bot, Maid Remake & Combat

Arsitektur otomasi komprehensif untuk farming, penyelesaian quest, dan pertempuran Ultra Boss:

### Core Bot Engine (BotManager)
- **Eksekusi Skrip (.gbot):** Otomasi penuh alur quest (Accept/Turn-in), penyerangan monster, pengambilan drop item, istirahat (Rest), pembelian/penjualan item, taunt, dan jeda kustom.
- **Interactive Macro Editor:** Editor instruksi visual dengan dukungan seleksi multi-baris, *drag-and-drop*, dan pintasan keyboard lengkap.
- **Aura Tracking System:** Pelacakan durasi, jumlah stack, serta status buff/debuff pemain dan monster secara *real-time* (`AuraSystem`).
- **Dynamic DropStack & Item Safety:** Perhitungan dinamis kapasitas maksimal stack (`Item.GetMaxStack`) dari metadata item/shop untuk mencegah item terbuang saat inventori penuh.
- **High-Efficiency Inventory & Bank Engine:** Sistem pencarian item cepat berbasis ID atau nama, validasi kuantitas (`Contains(name, quantity)`), verifikasi atribut koin AC/non-AC, dan validasi transaksi pada `CmdSell`.
- **Auto Re-login & Session Recovery:** Deteksi otomatis pemutusan koneksi dengan opsi re-login ke server target.

### Maid Remake (MaidRemake)
Modul asisten tempur dan otomasi party terpadu:
- **Auto-Follow Master:** Mengikuti pergerakan pemain target secara otomatis antar ruangan dan sel (`CellJumperHandler`, `JoinMapHandler`, `CopyWalkHandler`).
- **Party Chat Command Automation:** Menerima undangan party secara otomatis dan merespons perintah chat `/p` (seperti `.join {map}`, `.acc {id}`, `.turnin {id}`, `.target {player}`, `.start`, `.stop`, dll.).
- **Ultra Boss Mechanics Handler:** Penanganan logika mekanik khusus pada Ultra Boss (*Ultra Speaker, Ultra Gramiel, Ultra Warden, Dark Carnax, Malgor*, dll.) mencakup penyeimbangan HP monster dan pemecahan perisai (*shield breaking*).
- **Anti-Counter Attack Defense:** Mendeteksi status serangan balasan monster untuk mencegah kematian instan akibat memukul saat monster berada dalam kondisi *counter*.
- **Rotasi Skill, Buff, & Heal:** Pengaturan prioritas skill rotasi, penyembuhan HP darurat (*health percent threshold*), dan skill penguatan status.

---

## 4. Universal Plugin Compatibility Layer

Arsitektur runtime plugin yang andal dengan dukungan backwards-compatibility untuk ekosistem plugin Grimoire:
- **Binary Interface Compatibility (AppendDebug):** Menyediakan method overload lengkap (`AppendDebug(text)`, `AppendDebug(text, ignoreInvoke)`, dan `AppendDebug(text, ignoreInvoke, doAnyway)`) pada `LogForm` sehingga plugin pihak ketiga (seperti *ThreeManTaunter*, *ActionClient*, *Silencer*, dll.) berjalan normal tanpa kendala `MissingMethodException`.
- **Standardized Version Signature:** Format pengenalan versi pada `AboutForm.getVersion()` diselaraskan (`Version 2.3 (DDMMYYYY)`) untuk kompatibilitas penuh dengan manajer host eksternal (*ActionHost 2.3+*).
- **Isolated Plugin Loading:** Pemuatan dan pelepasan plugin secara dinamis dari direktori `Plugins/` dan `Plugins/unload/`.

---

## 5. Alat Bantu Tambahan & Opsi Klien (Tools & Options)

- **Cosmetics (CosmeticForm):** Mengubah tampilan visual armor, helm, senjata, jubah (cape), pet, dan class secara client-side.
- **Loaders & Grabbers (Loaders):** Menarik (*grab/scrape*) data Shop ID, Quest ID, Item Inventory, Bank Database, dan Entity Monster langsung dari memori game.
- **Drop UI (DropUi):** Antarmuka notifikasi dan manajemen drop item kustom yang dilengkapi fitur *Take Selected*, *Take All AC Drop* (otomasi pengambilan khusus item berstatus AC), *Reject & Blacklist*, penolakan otomatis drop non-AC in-game, serta *highlight* visual warna emas untuk item AC.
- **Client Options:**
  - *Infinite Range:* Menyerang target dari jarak tak terbatas.
  - *Provoke:* Menarik perhatian seluruh monster dalam sel secara agresif.
  - *Enemy Magnet:* Mengumpulkan posisi monster ke posisi karakter.
  - *Lag Killer & Hide Players:* Menyembunyikan avatar pemain lain dan efek animasi untuk memaksimalkan frame rate (FPS).
  - *Skip Cutscenes:* Melewati animasi cerita secara otomatis.
  - *Walkspeed Adjustment:* Mengatur kecepatan berjalan karakter.
- **Utilitas Tambahan:** Hotkeys manager, In-Game Notepad, Color Eye Dropper, dan SWF Dev Test form.

---

## Persyaratan Sistem

| Komponen | Spesifikasi Minimum / Rekomendasi |
| :--- | :--- |
| **Sistem Operasi** | Windows 7 / 8 / 10 / 11 (Arsitektur 32-bit & 64-bit) |
| **Runtime Lingkungan** | .NET Framework 4.7.2 atau versi lebih baru |
| **Komponen Flash** | Cleanflash / Adobe Flash Player ActiveX Control |
| **Arsitektur Kompilasi** | x86 (32-bit target) |

---

## Prosedur Kompilasi dan Eksekusi

### Metode 1: Menggunakan Skrip Kompilasi Otomatis (Direkomendasikan)
Gunakan skrip [build.ps1](file:///c:/Users/HP%20Elitebook%20X360/antigravity/aqw-grimcodex/build.ps1) yang secara otomatis mendeteksi instalasi MSBuild (Visual Studio 2019/2022 BuildTools, Community, Professional, atau Enterprise):
```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1
```

### Metode 2: Kompilasi Manual Menggunakan MSBuild CLI
Buka terminal PowerShell / Command Prompt dan jalankan:
```powershell
& "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe" "Project Grimlite.sln" /p:Configuration=Release /p:Platform=x86
```

### Direktori Output Biner
Biner hasil kompilasi siap digunakan di:
```text
bin\x86\Release\Grimoire.exe
```

---

## Daftar Pintasan Keyboard

| Kombinasi Tombol | Fungsi Operasional |
| :--- | :--- |
| **Ctrl + C** | Menyalin perintah bot yang dipilih (format serialisasi `.gbot`) |
| **Ctrl + V** | Menempelkan (*paste*) baris instruksi `.gbot` dari clipboard |
| **Ctrl + S** | Menyimpan skrip bot aktif ke file konfigurasi `.gbot` |
| **Ctrl + Panah Atas / Bawah** | Memindahkan urutan prioritas baris instruksi yang dipilih |
| **Ctrl + [Add Command]** | Menyisipkan perintah baru tepat di atas indeks baris yang dipilih |
| **Alt + [Add Command]** | Mengalihkan mode eksekusi perintah (contoh: *Normal Accept Quest* ke *Ghost Accept Quest*) |
| **Klik Ganda (Perintah Bot)** | Membuka jendela dialog editor detail instruksi |
| **Klik Ganda (Daftar Shop)** | Menjalankan prosedur pembukaan shop yang dipilih di Shop Pinner |
| **Klik Ganda (Log Paket)** | Menyalin string payload ke kolom input transmisi pada Packet Tamperer |

---

## Deployment Signaling Server (Voice Chat)

Direktori [signaling-server/](file:///c:/Users/HP%20Elitebook%20X360/antigravity/aqw-grimcodex/signaling-server/) memuat layanan relai berbasis Node.js WebSocket untuk distribusi sinyal audio yang siap diintegrasikan di balik **Cloudflare Proxy (WSS)**:

### 1. Inisialisasi pada Environment VPS (Debian / Ubuntu):
```bash
cd signaling-server
npm install
npm install -g pm2
pm2 start server.js --name "grimcodex-voice"
pm2 save
pm2 startup
```

### 2. Konfigurasi Nginx Reverse Proxy (WSS Port 443 dengan Cloudflare):
```nginx
server {
    listen 80;
    server_name voice.domainanda.com;

    location / {
        proxy_pass http://127.0.0.1:7030;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_read_timeout 86400s;
        proxy_send_timeout 86400s;
    }
}
```
*Catatan: Alternatif deployment tanpa eksposur port publik dapat menggunakan **Cloudflare Tunnel (`cloudflared`)** yang diarahkan ke `http://127.0.0.1:7030`.*

---

## Batasan Tanggung Jawab (Disclaimer)
*Perangkat lunak ini dikembangkan semata-mata untuk tujuan edukasi, riset protokol jaringan, dan studi arsitektur rekayasa perangkat lunak non-komersial. Pengembang tidak bertanggung jawab atas penyalahgunaan aplikasi yang bertentangan dengan ketentuan layanan pihak terkait.*

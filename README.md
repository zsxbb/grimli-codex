<div align="center">

# Grimlite Li x CODEX v2

**Advanced Client Architecture, Network Packet Engine, Cloud Script Bank & Automation Suite for AdventureQuest Worlds**

[![Release](https://img.shields.io/badge/Release-v2.0.2_Stable-brightgreen?style=for-the-badge&logo=github)](https://github.com/zsxbb/grimli-codex/releases/latest)
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

**Grimlite Li x CODEX v2.0.2** adalah platform modifikasi klien, otomasi tingkat lanjut, dan analisis protokol jaringan generasi baru untuk **AdventureQuest Worlds (AQW)**. Dikembangkan di atas arsitektur .NET Framework 4.7.2 (C# / Windows Forms) yang berpasangan secara langsung dengan runtime Flash ActiveX (Cleanflash), rilis v2 menghadirkan ekosistem otomasi terlengkap: **Codex Script Bank** (sinkronisasi cloud 75+ bot langsung dari GitHub), **In-App Auto-Updater** (pembaruan mandiri tanpa instal ulang), suite utilitas eksklusif **CODEX Suite**, sistem audio **Codex Voice Chat**, otomasi tim/multi-akun **Maid Remake**, serta **Core Bot Engine** berbasis logika kondisional berkemampuan tinggi.

---

## 📑 Daftar Isi

- [📥 Panduan Unduh & Instalasi Cepat](#-panduan-unduh--instalasi-cepat)
- [🏛️ Arsitektur Sistem Klien](#️-arsitektur-sistem-klien)
- [🖥️ Antarmuka Utama & Kontrol Akses Cepat](#️-antarmuka-utama--kontrol-akses-cepat)
- [🤖 Bedah Lengkap Bot Manager (.gbot Engine)](#-bedah-lengkap-bot-manager-gbot-engine)
  - [1. Tab Combat](#1-tab-combat)
  - [2. Tab Map & Navigasi](#2-tab-map--navigasi)
  - [3. Tab Quest](#3-tab-quest)
  - [4. Tab Item & Inventaris](#4-tab-item--inventaris)
  - [5. Tab Misc & Statement Engine (Logika Percabangan)](#5-tab-misc--statement-engine-logika-percabangan)
  - [6. Tab Options & Auto-Relogin](#6-tab-options--auto-relogin)
  - [7. Tab Options 2 & Tampilan Klien](#7-tab-options-2--tampilan-klien)
  - [8. Tab Bots (Penyimpanan & Metadata)](#8-tab-bots-penyimpanan--metadata)
- [👥 Maid Remake (Otomasi Multi-Akun & Army Support)](#-maid-remake-otomasi-multi-akun--army-support)
- [⚔️ CODEX Suite & Mekanik Khusus Ultra Boss](#️-codex-suite--mekanik-khusus-ultra-boss)
- [🌐 Network Toolkit & Packet Engine](#-network-toolkit--packet-engine)
- [🧰 Suite Peralatan & Fitur Ekstra (Tools Menu)](#-suite-peralatan--fitur-ekstra-tools-menu)
- [📝 Panduan Menyusun Skrip Bot (.gbot)](#-panduan-menyusun-skrip-bot-gbot)
- [⌨️ Daftar Pintasan Keyboard (Hotkeys)](#️-daftar-pintasan-keyboard-hotkeys)
- [💻 Kompilasi dari Source Code](#-kompilasi-dari-source-code)
- [🌐 Deployment Signaling Server (Voice Chat)](#-deployment-signaling-server-voice-chat)
- [❓ Tanya Jawab & Solusi Kendala (FAQ)](#-tanya-jawab--solusi-kendala-faq)
- [⚖️ Batasan Tanggung Jawab (Disclaimer)](#️-batasan-tanggung-jawab-disclaimer)

---

## 📥 Panduan Unduh & Instalasi Cepat

### Pengguna Baru (Install Pertama Kali):
1. Unduh paket rilis lengkap terbaru melalui tombol di atas atau halaman **[Releases](https://github.com/zsxbb/grimli-codex/releases/latest)**:
   👉 **`Grimlite-Li-x-CODEX-Full-Package.zip`**
2. Klik kanan file `.zip` tersebut > pilih **Extract All** ke folder mana pun di laptop Anda.
3. Jalankan **`Grimoire.exe`**.

### Pengguna Lama (Pembaruan Otomatis):
- Anda **tidak perlu mengunduh ulang file zip** secara manual.
- Cukup buka aplikasi Grimoire > klik menu **About** > pilih **Update App**.
- Aplikasi akan otomatis memeriksa manifest versi terbaru di GitHub, mengunduh file biner pembaruan di latar belakang, dan merestart dirinya sendiri ke versi terbaru!

---

## 🏛️ Arsitektur Sistem Klien

Grimlite Li x CODEX dirancang untuk menghadirkan kecepatan eksekusi tinggi tanpa mengorbankan stabilitas klien:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        Grimlite Li x CODEX UI                          │
│          (Windows Forms / DarkUI / C# .NET Framework 4.7.2)            │
└──────┬──────────────────────┬───────────────────────────┬──────────────┘
       │                      │                           │
       ▼                      ▼                           ▼
┌──────────────┐      ┌───────────────┐           ┌──────────────┐
│  Bot Engine  │      │  Maid Remake  │           │ CODEX Suite  │
│ (.gbot Loop) │      │ (Army Support)│           │ (Voice/Boss) │
└──────┬───────┘      └───────┬───────┘           └───────┬──────┘
       │                      │                           │
       └──────────────────────┼───────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────────┐
│                  ExternalInterface Flash-C# Bridge                     │
│                (Direct Memory Interception & Calls)                    │
└─────────────────────────────┬──────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────────┐
│                    Flash ActiveX Runtime (Cleanflash)                  │
│                AdventureQuest Worlds Game Engine (AS3)                 │
└─────────────────────────────┬──────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────────┐
│                  SmartFoxServer (SFS) Protocol Engine                  │
│             (%xt%, JSON, XML - Zero Socket Proxy Latency)              │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Host Flash ActiveX Terintegrasi:** Berjalan pada runtime Cleanflash/Flash Player ActiveX x86 dengan performa rendering visual tinggi dan konsumsi RAM yang terkendali.
2. **ActionScript Bridge Dua Arah (`ExternalInterface`):** Berkomunikasi langsung dengan memori Flash tanpa perantara proxy socket TCP lokal. Hal ini mengeliminasi risiko *packet loss*, *port conflict*, dan desinkronisasi data antara server dan klien.
3. **SmartFoxServer Protocol Interceptor:** Mencegat dan menyuntikkan paket string XT (`%xt%`), payload JSON, serta paket XML langsung di lapisan pesan game secara instan (*real-time*).
4. **Asynchronous Automation Thread:** Seluruh alur kerja bot berjalan pada thread latar belakang terisolasi sehingga antarmuka pengguna (UI) tetap responsif dan lancar selama proses farming berjalan intensif.

---

## 🖥️ Antarmuka Utama & Kontrol Akses Cepat

Jendela utama (**Root Window**) menyediakan pusat kendali instan tanpa harus membuka form terpisah:

### 1. Panel Akses Cepat (Top Quick Bar)
- **Start / Stop Bot (`chkStartBot`):** Memulai atau menghentikan eksekusi skrip bot yang sedang aktif secara instan.
- **Auto Attack (`chkAutoAttack`):** Mengaktifkan serangan otomatis terdekat tanpa memerlukan skrip bot berjalan.
- **Cell & Pad Jumper (`cbCells`, `cbPads`):** Dropdown dinamis berisi daftar seluruh Cell dan Pad di peta saat ini. Memungkinkan perpindahan ruangan dalam 1 klik.
- **Bank Shortcut (`btnBank`):** Membuka brankas bank secara langsung dari mana pun tanpa harus menghampiri NPC Bank.
- **Get Cell (`btnGetCell`):** Mengambil nama Cell dan Pad tempat karakter berdiri saat ini untuk mempermudah pencatatan skrip.

### 2. Sakelar Trik Game & Optimasi (Fast Options Toggles)
- **Infinite Range:** Mengizinkan karakter menyerang monster dari jarak tak terbatas di seluruh area cell.
- **Provoke Monsters:** Menarik perhatian (*aggro*) seluruh monster dalam ruangan secara serentak agar langsung menyerang pemain.
- **Enemy Magnet:** Mengumpulkan seluruh monster yang ada di cell agar berkumpul tepat di bawah kaki pemain.
- **Lag Killer:** Mematikan rendering visual grafis game untuk menghemat penggunaan CPU dan RAM secara drastis saat farming jangka panjang.
- **Hide Players:** Menyembunyikan avatar pemain lain untuk mengurangi beban visual di peta ramai (seperti `yulgar` atau `battleon`).
- **Skip Cutscenes:** Melewati dialog dan adegan sinematik secara otomatis seketika saat terpicu.
- **Disable Animations:** Mematikan animasi skill dan efek partikel monster/senjata untuk menstabilkan FPS.
- **Custom Walkspeed:** Mengatur kecepatan berjalan karakter di peta melebihi kecepatan standar.
- **Live Server Switcher:** Dropdown penggantian server instan dengan protokol re-login otomatis.
- **DPS Meter:** Overlay pengukur kerusakan per detik (DPS) serta total akumulasi damage.
- **Drop UI:** Antarmuka notifikasi drop item modern dengan opsi auto-loot dan penolakan item sampah.

---

## 🤖 Bedah Lengkap Bot Manager (.gbot Engine)

**Bot Manager** adalah dapur pacu utama untuk menyusun, mengedit, dan menjalankan skrip otomasi berformat `.gbot`. Dilengkapi tata letak tab yang komprehensif:

```
┌────────────────────────────────────────────────────────────────────────┐
│                              BOT MANAGER                               │
├─────────┬──────┬───────┬──────┬──────┬───────┬─────────┬──────────┬────┤
│ Combat  │ Map  │ Quest │ Hunt │ Item │ Misc  │ Options │ Options2 │Bots│
└─────────┴──────┴───────┴──────┴──────┴───────┴─────────┴──────────┴────┘
│ [Commands Tree/List]                  │ [Editor & Parameter Panel]     │
│  ├─ Join: icestormarena-1             │  Command: Kill For Item        │
│  ├─ Move to Cell: r3c, Left           │  Monster: *                    │
│  ├─ Quest: Accept [9250]              │  Item Name: Ice Diamond        │
│  ├─ Kill For: Ice Diamond (Qty: 10)   │  Quantity: 10                  │
│  └─ Quest: Complete [9250]            │  [ Add ]  [ Update ]  [ Delete]│
└───────────────────────────────────────┴────────────────────────────────┘
```

### 1. Tab Combat
Mengatur perilaku pertempuran, rotasi skill, dan pemulihan stamina:
- **Skill Rotations & Delays:** Memasukkan urutan skill (1 s/d 5) beserta jeda eksekusi milidetik yang dapat diatur per skill.
- **Safe MP & Safe HP:** Menetapkan batas minimum persentase HP dan MP sebelum skill berikutnya dapat digunakan, mencegah karakter kehabisan mana saat melawan boss kuat.
- **Rest System (HP/MP Rest):** Mengatur karakter untuk berhenti menyerang dan masuk ke mode istirahat (`Rest`) jika HP/MP berada di bawah ambang persentase tertentu, serta keluar dari mode istirahat saat penuh (`Exit Rest`).
- **Kill:** Menyerang monster spesifik berdasarkan nama atau tanda `*` (monster terdekat mana pun).
- **Kill For:** Memburu monster target hingga item tertentu terkumpul dalam jumlah yang ditentukan. Mendukung item inventaris normal maupun item quest sementara (*Temp Items*).
- **Skill Sets:** Mengelompokkan rotasi skill berbeda untuk kelas yang berbeda, yang dapat dipanggil bergantian di tengah skrip sesuai kebutuhan.

### 2. Tab Map & Navigasi
Mengelola perpindahan karakter di dunia AdventureQuest Worlds:
- **Join Map:** Memasuki map tertentu (misal: `tercessuinotlim`, `ultraspeaker`) dengan nomor ruangan publik atau privat (`mapname-999999`).
- **Cell & Pad Movement:** Melompat langsung ke Cell target (misal: `Enter`, `Boss`, `r1`, `r2`) dan Pad spawn (`Spawn`, `Left`, `Right`, `Center`).
- **Coordinate Walk (Walk X, Y):** Berjalan manual ke titik koordinat tertentu di layar permainan.
- **Random Walk:** Berjalan secara acak di sekitar cell untuk mensimulasikan pergerakan alami atau menghindari deteksi AFK.
- **Set Spawn:** Mengunci cell saat ini sebagai titik respawn karakter jika karakter mati.

### 3. Tab Quest
Mengelola alur siklus quest secara presisi:
- **Quest IDs:** Menentukan ID quest yang ingin dijalankan (bisa memuat beberapa quest sekaligus).
- **Auto Accept & Complete:** Mengambil quest secara instan dan menyerahkannya saat syarat selesai.
- **Reward Item Selector:** Mendukung penyerahan quest dengan pemilihan item hadiah tertentu (*Turn-in with Item ID*), sangat penting untuk quest dengan banyak opsi hadiah seperti *Nulgath (Larvae)* atau *Swindle Bilk*.
- **Quest List:** Memelihara daftar quest aktif yang otomatis diperbarui status penyelesaiannya di latar belakang.

### 4. Tab Item & Inventaris
Mengatur penanganan drop, inventaris, bank, dan perlengkapan:
- **Drop Whitelist & Blacklist:** Menyaring item yang harus otomatis diambil (`Get Drop`) dan mengabaikan item yang tidak diinginkan agar inventaris tidak penuh.
- **Bank Transfer & Swap:** Memindahkan item dari inventaris ke bank atau sebaliknya di tengah berjalannya bot untuk mengosongkan slot bag.
- **Buy / Fast Buy / Sell:** Membeli item dari toko menggunakan ID shop dan ID item secara instan, serta menjual item sampah hasil farm.
- **BuyBack:** Mengambil kembali item langka atau AC-tagged yang pernah dijual dari antarmuka buyback resmi.
- **Auto Equip / Equip Set:** Mengganti Class, Weapon, Helm, Armor, atau Cape secara dinamis (contoh: otomatis memakai Class Farming saat melawan monster biasa, lalu berganti ke Class Solo/Boss saat melawan Boss).
- **Map Item Interactor:** Mengambil item interaktif di peta (contoh: *buku, obor, kunci*) menggunakan Map Item ID.

### 5. Tab Misc & Statement Engine (Logika Percabangan)
Jantung kecerdasan Grimlite Li x CODEX terletak pada pustaka statement kondisionalnya. Tersedia **lebih dari 80 statement** untuk membuat logika percabangan kompleks:

#### A. Logika Alur & Kontrol:
- **Label & GotoLabel:** Membuat penanda alur (*bookmark*) dan melompat ke label tertentu saat kondisi terpenuhi.
- **Index Management (`GotoIndex`, `GoUpIndex`, `GoDownIndex`):** Memanipulasi indeks baris instruksi bot secara matematis.
- **Custom Variables & Integer:** `SetVar`, `UpdateVar`, `VarEqualVar`, `IntEqualInt`, `IntGreaterThan`, `IntLessThan` untuk menyimpan counter perulangan (*loop counter*).
- **Delay, Bot Delay & Packet Delay:** Menyesuaikan jeda waktu eksekusi agar aman dari penalti spam server.
- **Call Script (`LoadBot`):** Menjalankan file `.gbot` lain secara berantai setelah skrip saat ini selesai (*bot chaining*).
- **Beep & Sound Alert:** Membunyikan nada peringatan saat item langka drop atau quest penting selesai.

#### B. Statement Evaluasi Kondisi (Conditions):
| Kategori | Contoh Statement Tersedia |
| :--- | :--- |
| **Inventaris & Bank** | `InInventory`, `NotInInventory`, `InBank`, `NotInBank`, `InTemp`, `NotInTemp`, `InBankOrInvent`, `NotInBankAndInvent`, `IsMaxStack`, `IsNotMaxStack`, `ItemPickupable`, `ItemNotPickupable` |
| **Pemain (Player State)** | `HealthGreaterThan`, `HealthLessThan`, `ManaGreaterThan`, `ManaLessThan`, `PlayerHPGreaterThan`, `PlayerHPLessThan`, `InCombat`, `NotInCombat`, `CellIs`, `CellIsNot`, `MapIs`, `MapIsNot`, `Equipped`, `NotEquipped`, `FactionRankGreaterThan`, `FactionRankLessThan`, `GoldGreaterThan`, `LevelIs`, `IsMember` |
| **Monster & Target** | `MonsterInRoom`, `MonsterNotInRoom`, `HasTarget`, `NotHasTarget`, `MonsterHealthGreaterThan`, `MonsterHealthLessThan`, `TargetHealthBetween`, `TargetHealthGreaterThan`, `TargetHealthLessThan`, `TargetAuraEquals`, `TargetAuraDuration` |
| **Aura & Buff** | `PlayerAuraEquals`, `PlayerAuraGreaterThan`, `PlayerAuraLessThan`, `TargetAuraGreaterThan`, `TargetAuraLessThan` |
| **Quest State** | `QuestAvailable`, `QuestNotAvailable`, `QuestInProgress`, `QuestNotInProgress`, `QuestCompleted`, `QuestNotCompleted` |
| **Pemain Lain (Room State)**| `PlayerInRoom`, `PlayerNotInRoom`, `PlayerIsInCell`, `PlayerIsNotInCell`, `PlayerIsInMyCell`, `PlayerInMyCellGreaterThan`, `PlayersGreaterThan`, `PlayersLessThan` |

### 6. Tab Options & Auto-Relogin
- **Smart Auto Re-Login:** Jika koneksi terputus (*disconnect / server kick*), sistem akan menunggu jeda terkalibrasi (`numRelogDelay`), masuk kembali ke server pilihan, membuka peta terakhir, dan melanjutkan bot tepat dari titik terputus.
- **Audio Item Alert:** Memberikan alarm suara khusus saat nama item tertentu muncul di log drop.
- **Walking Speed & FPS Adjustment:** Mengubah kecepatan langkah avatar dan batas frame-rate rendering game.

### 7. Tab Options 2 & Tampilan Klien
- **Client-Side Alignment Modifier:** Mengubah afinitas faksi karakter di layar lokal menjadi *Good*, *Evil*, *Chaos*, atau *Undecided*.
- **Client-Side Access Level:** Mengubah status akun di layar lokal menjadi *Member* atau *Moderator*.
- **Chat Mute Toggle:** Mematikan pesan chat global untuk menjaga fokus dan privasi tampilan.
- **Custom Command Syntax Colors:** Mengatur palet warna setiap kategori perintah bot pada list box (dikonfigurasi melalui `CommandColorForm`).

### 8. Tab Bots (Penyimpanan & Metadata)
- **Hierarchical TreeView:** Menampilkan struktur folder bot lokal dan folder cloud CodexBank secara rapi.
- **Metadata Skrip:** Menampilkan nama author, deskripsi skrip, dan instruksi khusus sebelum bot dijalankan.
- **Pencarian Bot:** Memudahkan menemukan skrip bot di antara puluhan file yang tersimpan.

---

## 👥 Maid Remake (Otomasi Multi-Akun & Army Support)

**Maid Remake** adalah sistem kontrol terpusat untuk bermain bersama tim, multi-akun (*army*), maupun bot pendukung (*support bots*):

```
                       ┌──────────────────────┐
                       │   Master / Leader    │
                       │   (Akun Utama Anda)  │
                       └──────────┬───────────┘
                                  │
         ┌────────────────────────┼────────────────────────┐
         │ Mengirim instruksi via │ chat party (/p)        │
         ▼                        ▼                        ▼
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  Maid Bot 1     │      │   Maid Bot 2    │      │   Maid Bot 3    │
│  ArchPaladin    │      │  Lord of Order  │      │  StoneCrusher   │
│  (Heal & Buff)  │      │  (Full Buffs)   │      │  (Haste & Mana) │
└─────────────────┘      └─────────────────┘      └─────────────────┘
```

### Fitur Utama Maid Remake:
1. **Master-Follower Synchronizer:**
   - **CellJumperHandler:** Karakter follower langsung melompat ke cell master seketika master berganti ruangan.
   - **CopyWalkHandler:** Karakter follower meniru pergerakan dan posisi koordinat berdiri master.
   - **JoinMapHandler:** Karakter follower otomatis mengikuti master berpindah peta atau server.
2. **Party Chat Command Protocol (`/p`):**
   Master dapat memerintah seluruh follower secara bersamaan hanya dengan mengetik perintah berikut di chat party:
   - `.join <mapname-room>` : Memerintahkan seluruh follower masuk ke peta tertentu.
   - `.acc <questId>` : Memerintahkan seluruh follower mengambil quest yang ditentukan.
   - `.turnin <questId>` : Memerintahkan seluruh follower menyerahkan quest.
   - `.target <playername>` : Mengalihkan target master baru untuk seluruh follower.
   - `.start` / `.stop` : Menyalakan atau mematikan modul Maid pada semua follower.
3. **Preset Kelas Siap Pakai (*Class Presets*):**
   Sudah dikonfigurasi logika skill optimal untuk berbagai class support dan solo:
   - **AP (ArchPaladin):** Auto heal prioritas pada persentase HP rendah + debuff Commandment/Righteous Seal.
   - **LoO (Lord of Order):** Auto rotasi 4 buff esensial secara konstan.
   - **SC (StoneCrusher):** Sinkronisasi buff Endless Horizon & Magnitude.
   - **LR (Legion Revenant):** Rotasi buff Atramentous Shield, Depravity, dan Anathema.
   - **AI (Arcana Invoker), AM (ArchMage), CSH (Chaos Slayer), CCMD, DoT, Cav, VHL, TK**.
4. **Whitelist & Locked Map Protection:**
   Mencegah karakter follower tersangkut saat map tujuan memerlukan quest pembuka tertentu (*Locked Map Fallback*).

---

## ⚔️ CODEX Suite & Mekanik Khusus Ultra Boss

Suite utilitas tingkat tinggi yang dirancang khusus untuk menaklukkan konten paling sulit di AQW:

### 1. Codex Script Bank (Cloud Sync)
Pustaka skrip resmi yang terhubung langsung dengan GitHub repository:
- **75+ Skrip & Konfigurasi Teruji:**
  - **Endgame Classes:** Archmage (Part 1 s/d 9 lengkap), Legion Revenant (Fealty 1-3), Void Highlord, Arcana Invoker, Dragon of Time.
  - **Farming Material:** Darkon (Melody, Teeth, Remnant, Banana, Suki Prestige), Lae Dark Knight, Nulgath Nation reagents, Legion tokens.
  - **Ultra Bosses:** Drakath, Dark Carnax, Ultra Dage, Darkon, Drago, Nulgath, TimeInn trio, Tyndarius, Warden, Speaker (Apex).
  - **Dungeon & Solo:** Ascend Eclipse, Midnight Sun, Solstice Moon, Auto Grim Dungeon, IceStormArena, Reputations.
- **Folder Aman & Rapi:** Seluruh bot cloud tersimpan di folder `Bots/CodexBank/`, aman dan terisolasi dari skrip buatan Anda di folder `Bots/`.

### 2. Skill Moment (CodexSkillForm)
Respon mekanik bos secara instan berbasis *event* pemicu:
- **Trigger by Red Warning Message:** Membaca pesan teks peringatan bos (misal: pesan serangan mematikan dari Ultra Tyndarius atau Warden).
- **Trigger by Boss HP Percentage:** Memicu skill saat HP bos menyentuh batas tertentu (misal: phase change pada 50% HP).
- **Instant Reaction:** Langsung mengaktifkan Skill Taunt (*Scroll of Enrage*), Shield, atau Heal dengan jeda milidetik terkalibrasi.

### 3. Loop Aura / Enrage (CodexEnrageForm & TauntCycle)
Mencegah terjadinya tabrakan taunt (*overlapping taunt*) di pertarungan Ultra Boss:
- Memantau paket SmartFoxServer secara langsung saat aura `Focus` atau debuff lainnya masuk dan berakhir (`aura+` / `aura-`).
- Mengeksekusi taunt berikutnya tepat pada milidetik aura sebelumnya habis dengan pengecekan ketersediaan skill pemain (`Player.SkillAvailable`).

### 4. Automated Ultra Boss Handlers (Network Layer)
Handler khusus yang ditanam langsung pada logika jaringan untuk merespons mekanik boss otomatis:
- **HandlerUltraSpeakerMechanics:** Menangani pembagian zone dan penyeimbangan HP pada pertarungan Ultra Speaker (Apex Malgor).
- **HandlerUltraGramielTaunt:** Mengatur siklus taunt teratur pada pertarungan Ultra Gramiel (Left & Right orbs).
- **HandlerAutoZone (Dark Carnax, Ultra Dage, Queen Iona, Vordred, Astral Empyrean):** Otomatis berpindah zona aman saat boss mengeluarkan serangan area lantai (*floor wipe*).
- **Anti-Counter Attack Protection:** Otomatis menghentikan seluruh serangan dan skill ketika boss berada dalam mode pantulan serangan (*counter attack shield*), mencegah kematian instan seluruh anggota party.

### 5. Bypass Map (BypassMapForm)
- Membuka gerbang peta terkunci dan melewati seluruh persyaratan alur cerita quest secara instan di sisi klien (`strQuests` injection).
- Menampilkan monster tersembunyi tanpa merusak integritas data akun di server.

### 6. Quest & Shop Pinner
- **Quest Pinner:** Menyematkan quest Ultra Boss mingguan dan harian untuk diambil dan diserahkan dalam 1 klik tanpa harus mendatangi NPC.
- **Shop Pinner:** Membuka toko perlengkapan di mana pun dengan protokol perjalanan aman (*Safe Travel & Load Shop*).

### 7. Codex Voice Chat
Sistem komunikasi suara berlatensi rendah yang terpasang langsung di dalam klien:
- **Spatial / Room Isolation:** Suara hanya terdengar oleh pemain yang berada di Server, Map, dan Cell yang sama.
- **Kompresi Audio Opus 48kHz:** Kualitas vokal jernih dengan konsumsi bandwidth sangat rendah.
- **Kontrol Audio Terpadu:** Mic Boost hingga 300%, Volume Output hingga 200%, VAD (Voice Activity Detection), dan live VU Meter.

---

## 🌐 Network Toolkit & Packet Engine

Bagi pengembang bot dan peneliti protokol SmartFoxServer, Grimlite Li x CODEX menyediakan perangkat inspeksi paket terlengkap:

- **Packet Tamperer:** Mencegat paket masuk dan keluar, menyaring string kata kunci, mengganti isi paket secara langsung sebelum dikirim ke server, dan menghapus prefix otomatis (*Auto-Strip Prefix*).
- **Packet Logger / Sniffer:** Mencatat seluruh transaksi paket SFS (XT, JSON, XML) secara terperinci dengan timestamp real-time.
- **Packet Spammer:** Mengirimkan paket berulang kali dengan jeda milidetik presisi. Mendukung variabel makro dinamis:
  - `{PLAYERNAME}` : Digantikan dengan nama karakter Anda saat ini.
  - `{ROOM_ID}` : Digantikan dengan nomor room saat ini.
  - `{MAP}` : Digantikan dengan nama map saat ini.
- **Packet Interceptor:** Membekukan alur paket untuk analisis struktur muatan pesan.

---

## 🧰 Suite Peralatan & Fitur Ekstra (Tools Menu)

- **Fast Travels:** Menu navigasi instan ke puluhan lokasi populer di AQW.
- **Loaders & Grabbers:** Mengambil daftar ID shop, quest, monster, cell map, inventory data, serta memuat file SWF langsung dari server Artix.
- **Cosmetic Form:** Mengubah tampilan armor, senjata, helm, dan jubah secara visual di layar Anda tanpa harus memiliki item aslinya.
- **DPS Tracker (DPSForm):** Menganalisis efisiensi rotasi skill, total damage dealt, dan rata-rata DPS.
- **Hotkeys Manager:** Mengatur tombol shortcut keyboard kustom untuk membuka menu, melompat cell, atau menyalakan bot.
- **In-App Notepad:** Buku catatan terintegrasi untuk menyimpan ID quest, catatan kombo, atau daftar belanja item.
- **Eye Dropper:** Pengambil sampel warna layar untuk menyamakan warna rambut, kulit, atau armor karakter.
- **Plugin Manager:** Mendukung pemuatan modul plugin tambahan berbentuk DLL C# berbasis antarmuka `IPlugin`.

---

## 📝 Panduan Menyusun Skrip Bot (.gbot)

Struktur skrip bot yang baik terdiri dari 5 tahap siklus:

```
[ Inisialisasi ] ──> Masuk Map & Atur Cell ──> Ambil Quest
                                                     │
[ Turn-in & Loop ] <── Cek Syarat Selesai <── Serang Monster
```

### Contoh Alur Skrip Farming yang Efisien:
1. **Join & Move:**
   ```text
   Join: icestormarena-1, r3c, Left
   ```
2. **Accept Quest:**
   ```text
   Quest: Accept [9250]
   ```
3. **Combat Loop (Menggunakan Statement):**
   ```text
   Label: FARM
   Kill For: Ice Diamond (Qty: 10, Temp: False)
   Statement: InInventory("Ice Diamond", 10)
     GotoLabel: COMPLETE
   GotoLabel: FARM
   ```
4. **Complete Quest & Restart:**
   ```text
   Label: COMPLETE
   Quest: Complete [9250]
   Delay: 1000 ms
   GotoLabel: FARM
   ```

### Tips Best Practice:
- Berikan **Delay aman (500–1000 ms)** setelah penyerahan quest untuk menghindari penolakan paket dari server.
- Selalu gunakan **Drop Whitelist** untuk item target agar tidak terlewatkan saat drop muncul.
- Manfaatkan **Safe MP / Safe HP** agar karakter tidak mati konyol saat melawan monster dengan damage tinggi.

---

## ⌨️ Daftar Pintasan Keyboard (Hotkeys)

| Kombinasi Tombol | Fungsi Operasional |
| :--- | :--- |
| **Ctrl + C** | Menyalin baris perintah bot yang dipilih (format serialisasi `.gbot`) |
| **Ctrl + V** | Menempelkan (*paste*) baris instruksi `.gbot` dari clipboard |
| **Ctrl + S** | Menyimpan konfigurasi bot aktif ke file `.gbot` |
| **Ctrl + Panah Atas / Bawah** | Memindahkan urutan prioritas baris instruksi yang dipilih |
| **Ctrl + [Add Command]** | Menyisipkan perintah baru tepat di atas indeks baris yang dipilih |
| **Alt + [Add Command]** | Mengalihkan mode eksekusi perintah (contoh: *Normal Accept* ke *Ghost Accept*) |
| **Klik Ganda (Perintah Bot)** | Membuka jendela dialog editor detail instruksi |
| **Klik Ganda (Daftar Shop)** | Menjalankan prosedur pembukaan toko di Shop Pinner |
| **Klik Ganda (Log Paket)** | Menyalin string payload ke kolom input Packet Tamperer |

---

## 💻 Kompilasi dari Source Code

### Prasyarat:
- Sistem Operasi: Windows 7 / 8 / 10 / 11 (32-bit & 64-bit)
- **.NET Framework 4.7.2 Developer Pack**
- **Visual Studio 2022** (dengan workload *.NET Desktop Development*)

### Kompilasi Otomatis via PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1
```

Biner hasil kompilasi akan otomatis siap dijalankan di folder:
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

## ❓ Tanya Jawab & Solusi Kendala (FAQ)

### 1. Game macet di layar putih / hitam saat dibuka (Flash Player issue)?
Pastikan Anda telah menginstal runtime **Cleanflash** (Flash Player ActiveX untuk Windows). Grimlite Li memerlukan komponen ActiveX Flash 32-bit agar dapat memuat antarmuka game AQW.

### 2. Apakah bot cloud di Codex Script Bank aman digunakan?
Seluruh skrip di Codex Script Bank telah melalui peninjauan dan pengujian di server resmi untuk memastikan efisiensi rute quest, jeda anti-kick, serta penanganan item drop yang tepat.

### 3. Karakter sering terputus (*disconnect*) saat berpindah map?
Aktifkan opsi **Safe Delay** dan naikkan **Relog Delay** di Tab Options menjadi minimal 3000–5000 ms. Pastikan koneksi internet Anda stabil dan tidak terjadi lonjakan ping.

### 4. Di mana letak penyimpanan file skrip bot saya?
- Skrip pribadi Anda berada di: `Bots\`
- Skrip cloud Codex Bank berada di: `Bots\CodexBank\` (diisolasi agar tidak menimpa skrip buatan Anda).

---

## ⚖️ Batasan Tanggung Jawab (Disclaimer)

*Perangkat lunak ini dikembangkan semata-mata untuk tujuan edukasi, riset protokol jaringan, dan studi arsitektur rekayasa perangkat lunak non-komersial. Pengembang tidak bertanggung jawab atas segala bentuk penyalahgunaan aplikasi yang bertentangan dengan ketentuan layanan pihak penyedia game terkait.*

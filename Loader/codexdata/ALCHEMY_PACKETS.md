# AQW Alchemy Packet Formula Documentation (Post-Patch Update)

Dokumentasi rumus formula packet alchemy (*START* & *COMPLETE*) yang diperbarui setelah update/patch sistem Alchemy AQW (Chemicotron interface), dipetakan langsung dengan dataset [`database/packet_alchemy.json`](file:///pxnda/sakib.my.id/aqw/database/packet_alchemy.json).

---

## 1. Format Formula Packet

Setiap proses brewing potion menggunakan dua packet yang dikirimkan secara berurutan dengan jeda waktu server-side validation:

### A. Packet START (`alchStart`)
Memberi tahu server untuk memulai proses brewing dengan reagen yang dipilih.
```text
%xt%zm%crafting%1%alchStart%{Reagent 1 ID}%{Reagent 2 ID}%{Alchemy Rune}%1%{Trait}%
```
*Respon Server*: `{"t":"xt","b":{"r":-1,"o":{"cmd":"alchStart","ok":1}}}`

### B. Packet COMPLETE (`alchDone`)
Memberi tahu server bahwa proses mixing selesai untuk mengklaim hasil potion ke inventory.
```text
%xt%zm%crafting%1%alchDone%
```
*Respon Server*: `turnIn` (reagen dikurangi), `addItems` (+7 potion), `ccqr` (quest complete), `alchDone ok: 1`.

---

## 2. Pemetaan Field JSON

Field dari setiap item di [`packet_alchemy.json`](file:///pxnda/sakib.my.id/aqw/database/packet_alchemy.json):

| Placeholder | Key di `packet_alchemy.json` | Tipe | Nilai Fallback | Keterangan |
| :--- | :--- | :--- | :--- | :--- |
| `{Reagent 1 ID}` | `"Reagent 1 ID"` | String | `""` | ID item reagen pertama |
| `{Reagent 2 ID}` | `"Reagent 2 ID"` | String | `""` | ID item reagen kedua (kosong bila `None`) |
| `{Alchemy Rune}` | `"Alchemy Rune"` | String | `""` | *Jera*, *Fehu*, *Gebo*, *Uruz* |
| `1` | Katalis | Integer | `1` | Dragon Runestone katalis aktif |
| `{Trait}` | `"Trait"` | String | `""` | *Moose*, *Eva*, *End*, *Wis*, *Dam*, dll. |

### Catalyst Wajib (Inventory)
| Item Catalyst | Item ID | Kebutuhan | Keterangan |
| :--- | :--- | :--- | :--- |
| **Dragon Runestone** | `7132` | 1x per brew | **Wajib ada di inventory** untuk setiap kali brewing. Tanpa item ini di inventory, server tidak akan memproses racikan potion dari daftar ini. |

> **Catatan Resep 1 Reagen**:
> Bila reagen 2 bernilai `"None"`, maka `{Reagent 2 ID}` bernilai kosong `""`.  
> Contoh: `%xt%zm%crafting%1%alchStart%11469%%Fehu%1%Moose%`

---

## 3. Syarat & Konfigurasi Eksekusi Timing

Sesuai update patch sistem Alchemy:
1. **Syarat Karakter**: Minimal **Rank 8 Alchemy**.
2. **Item yang Wajib Dimiliki di Inventory**:
   - **Dragon Runestone** (Item ID: `7132`) — Dikonsumsi 1x per attempt.
   - **Reagent 1** (misal: *Arashtite Ore*, *Doomatter*, *Chaoroot*, dll.)
   - **Reagent 2** (jika resep membutuhkan 2 reagen)
3. **Alur & Siklus Waktu (*Timing Cycle*)**:
   - **Langkah 1**: Kirim packet `alchStart`
   - **Langkah 2**: Tunggu **18 detik (18.000 ms)** (durasi mini-game wajar server agar tidak ditolak dengan pesan *"Finished too quickly"*).
   - **Langkah 3**: Kirim packet `alchDone`
   - **Langkah 4**: Cooldown istirahat **2 detik (2.000 ms)** sebelum mengulang kembali ke Langkah 1.

---

## 4. Contoh Nyata Berdasarkan Data

### Contoh 1: Formula 2 Reagen (Accuracy Elixir)
```json
{
  "Potion Name": "Accuracy Elixir",
  "Reagent 1": "Arashtite Ore",
  "Reagent 1 ID": "11473",
  "Reagent 2": "Nimblestem",
  "Reagent 2 ID": "11469",
  "Alchemy Rune": "Jera",
  "Trait": "Moose"
}
```
* **Packet START**:
  ```text
  %xt%zm%crafting%1%alchStart%11473%11469%Jera%1%Moose%
  ```
* **Wait**: 18 detik (18.000 ms)
* **Packet COMPLETE**:
  ```text
  %xt%zm%crafting%1%alchDone%
  ```
* **Cooldown**: 2 detik (2.000 ms)

### Contoh 2: Formula 1 Reagen (Aim Elixir)
```json
{
  "Potion Name": "Aim Elixir",
  "Reagent 1": "Nimblestem",
  "Reagent 1 ID": "11469",
  "Reagent 2": "None",
  "Reagent 2 ID": "",
  "Alchemy Rune": "Fehu",
  "Trait": "Moose"
}
```
* **Packet START**:
  ```text
  %xt%zm%crafting%1%alchStart%11469%%Fehu%1%Moose%
  ```
* **Wait**: 18 detik (18.000 ms)
* **Packet COMPLETE**:
  ```text
  %xt%zm%crafting%1%alchDone%
  ```
* **Cooldown**: 2 detik (2.000 ms)

---

## 5. Skrip Pengolahan Data

### A. Node.js Script
Gunakan skrip ini untuk membaca [`database/packet_alchemy.json`](file:///pxnda/sakib.my.id/aqw/database/packet_alchemy.json) dan menghasilkan field `Packet START` & `Packet COMPLETE`:

```javascript
const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'packet_alchemy.json');
const rawData = fs.readFileSync(filePath, 'utf8');
const alchemyList = JSON.parse(rawData);

const enrichedList = alchemyList.map(item => {
    const p1 = item['Reagent 1 ID'] || '';
    const p2 = item['Reagent 2 ID'] || '';
    const n1 = item['Reagent 1'] || '-';
    const n2 = item['Reagent 2'] || '-';
    const rune = item['Alchemy Rune'] || '';
    const trait = item['Trait'] || '';

    const packetStart = `%xt%zm%crafting%1%getAlchWait%${p1}%${p2}%true%Ready to Mix%${n1}%${n2}%${rune}%${trait}%`;
    const packetComplete = `%xt%zm%crafting%1%checkAlchComplete%${p1}%${p2}%true%Mix Complete%${n1}%${n2}%${rune}%${trait}%`;

    return {
        ...item,
        "Runestone": "Dragon Runestone",
        "Runestone ID": "7132",
        "Packet START": packetStart,
        "Packet COMPLETE": packetComplete
    };
});

// Simpan hasil ke file baru atau overwrite jika diinginkan:
fs.writeFileSync(path.join(__dirname, 'packet_alchemy_enriched.json'), JSON.stringify(enrichedList, null, 2), 'utf8');
console.log(`Berhasil memproses ${enrichedList.length} resep potion.`);
```

### B. Python Script (Alternatif)
```python
import json
from pathlib import Path

file_path = Path(__file__).parent / "packet_alchemy.json"
with open(file_path, "r", encoding="utf-8") as f:
    data = json.load(f)

for item in data:
    p1 = item.get("Reagent 1 ID") or ""
    p2 = item.get("Reagent 2 ID") or ""
    n1 = item.get("Reagent 1") or "-"
    n2 = item.get("Reagent 2") or "-"
    rune = item.get("Alchemy Rune") or ""
    trait = item.get("Trait") or ""

    item["Runestone"] = "Dragon Runestone"
    item["Runestone ID"] = "7132"
    item["Packet START"] = f"%xt%zm%crafting%1%getAlchWait%{p1}%{p2}%true%Ready to Mix%{n1}%{n2}%{rune}%{trait}%"
    item["Packet COMPLETE"] = f"%xt%zm%crafting%1%checkAlchComplete%{p1}%{p2}%true%Mix Complete%{n1}%{n2}%{rune}%{trait}%"

output_path = Path(__file__).parent / "packet_alchemy_enriched.json"
with open(output_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"Selesai memproses {len(data)} potion.")
```

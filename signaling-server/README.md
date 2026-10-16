# GrimCodex Voice Relay Server (WebSocket WSS via Cloudflare)

Server ini bertindak sebagai voice relay & room presence yang aman di balik **Cloudflare Proxy (Awan Oranye)**.
Dengan arsitektur ini:
- **IP VPS 100% Tersembunyi** (orang lain hanya melihat IP Anycast Cloudflare `104.x.x.x`).
- **Anti-DDoS Gratis** dari Cloudflare.
- **SSL Otomatis** gratis dari Cloudflare.
- **NAT / Firewall Bypassed** (koneksi WSS port 443 selalu tembus tanpa konfigurasi router rumit).

---

## 🚀 Panduan Setup Cepat di VPS (Ubuntu/Debian)

### 1. Upload Folder Ini ke VPS
Upload file `server.js` dan `package.json` ke folder di VPS Anda (misalnya `/var/www/voice-relay` atau `~/voice-relay`).

### 2. Install Dependensi
```bash
cd voice-relay
npm install
```

### 3. Jalankan Server
Untuk test langsung:
```bash
node server.js
```

Untuk menjalankan di background terus menerus (auto-restart saat server reboot):
```bash
npm install -g pm2
pm2 start server.js --name "grimcodex-voice"
pm2 save
pm2 startup
```

---

## ☁️ Pengaturan Cloudflare & Reverse Proxy

### Opsi A (Paling Mudah: Menggunakan Nginx Reverse Proxy di VPS)
Konfigurasi Nginx di `/etc/nginx/sites-available/voice.domainanda.com`:
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
Lalu:
```bash
sudo ln -s /etc/nginx/sites-available/voice.domainanda.com /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```
Di Cloudflare:
- Tambahkan DNS Record **A**: `voice` -> `IP_VPS_ANDA`
- Status Proxy: **Proxied (Awan Oranye ☁️🧡)**
- Di menu **SSL/TLS**: Pilih mode **Flexible** (atau **Full** jika pasang certbot SSL).

### Opsi B (Tanpa Nginx: Menggunakan Cloudflare Tunnel / `cloudflared`)
1. Di Cloudflare Dashboard: Zero Trust -> Networks -> Tunnels -> Create Tunnel.
2. Pasang perintah `cloudflared` yang diberikan di VPS.
3. Hubungkan Public Hostname: `voice.domainanda.com` -> Service: `HTTP` `127.0.0.1:7030`.
4. Selesai! Port VPS bahkan tidak perlu dibuka sama sekali ke internet.

---

## 🎮 Penggunaan di Grimoire Client
1. Buka Grimoire -> **Menu Codex** -> **Voice Chat**.
2. Masukkan URL server: `wss://voice.domainanda.com` di kotak **Server (WSS)**.
3. Centang **Enable Voice Chat**.
4. Selesai! Anda dan teman satu room/cell langsung bisa saling berbicara secara realtime.

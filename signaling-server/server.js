/**
 * GrimCodex Voice Chat - WebSocket Signaling & Audio Relay Server (v2.0)
 * Designed for Cloudflare Proxy (WSS / HTTPS Port 443)
 * 
 * IP VPS Anda 100% AMAN di balik Cloudflare.
 * 
 * Setup di Ubuntu VPS:
 * 1. npm install ws
 * 2. node grimcodex-signaling.js
 *    (atau jalankan background pakai: pm2 start grimcodex-signaling.js --name "voice-relay")
 */

const http = require('http');
const { WebSocketServer, WebSocket } = require('ws');

const PORT = process.env.PORT || 7030;

// HTTP Server untuk health-check dan WebSocket upgrade
const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('GrimCodex Voice Signaling & Audio Relay Server (WebSocket) is RUNNING!\n');
});

// WebSocket Server
const wss = new WebSocketServer({ server });

console.log('===========================================================');
console.log(` GrimCodex WebSocket Voice Server starting on port ${PORT}...`);
console.log('===========================================================');

wss.on('connection', (ws, req) => {
    const ip = req.headers['cf-connecting-ip'] || req.headers['x-forwarded-for'] || req.socket.remoteAddress;
    console.log(`[WS Connected] Peer connected from ${ip}`);

    ws.isAlive = true;
    ws.username = '';
    ws.server = '';
    ws.map = '';
    ws.cell = '';

    ws.on('pong', () => {
        ws.isAlive = true;
    });

    ws.on('message', (data, isBinary) => {
        try {
            if (isBinary) {
                // --- RELAY AUDIO BINARY ---
                // Format Paket: [1 byte: username length][username UTF-8][Opus audio payload]
                if (data.length < 2) return;

                // Verifikasi sender sudah terdaftar server, map & cell-nya
                if (!ws.server || !ws.map || !ws.cell) return;

                // Teruskan paket audio HANYA ke pemain di Server, Map & Cell yang SAMA
                for (const client of wss.clients) {
                    if (
                        client !== ws &&
                        client.readyState === WebSocket.OPEN &&
                        client.server === ws.server &&
                        client.map === ws.map &&
                        client.cell === ws.cell
                    ) {
                        client.send(data, { binary: true });
                    }
                }
            } else {
                // --- PRESENCE & ROOM UPDATE (JSON TEXT) ---
                const str = data.toString('utf8');
                const msg = JSON.parse(str);

                if (msg.action === 'update') {
                    const oldServer = ws.server;
                    const oldMap = ws.map;
                    const oldCell = ws.cell;

                    ws.username = (msg.username || '').trim();
                    ws.server = (msg.server || '').trim().toLowerCase();
                    ws.map = (msg.map || '').trim().toLowerCase();
                    ws.cell = (msg.cell || '').trim().toLowerCase();

                    console.log(`[Presence Update] ${ws.username} -> Server: "${ws.server}", Map: "${ws.map}", Cell: "${ws.cell}"`);

                    // Jika player berpindah server/map/cell, beritahu peer di room lama bahwa dia sudah keluar
                    if (oldMap && oldCell && (oldServer !== ws.server || oldMap !== ws.map || oldCell !== ws.cell) && ws.username) {
                        broadcastOffline(ws.username, oldServer, oldMap, oldCell, ws);
                    }
                }
            }
        } catch (err) {
            console.error('[WS Message Error]:', err.message);
        }
    });

    ws.on('close', () => {
        console.log(`[WS Disconnect] ${ws.username || 'Anonymous'} disconnected`);
        if (ws.username && ws.map && ws.cell) {
            broadcastOffline(ws.username, ws.server, ws.map, ws.cell, ws);
        }
    });

    ws.on('error', (err) => {
        console.error(`[WS Error] ${ws.username || 'Unknown'}:`, err.message);
    });
});

function broadcastOffline(username, serverName, map, cell, senderWs) {
    const offlinePayload = JSON.stringify({
        action: 'offline',
        username: username
    });

    for (const client of wss.clients) {
        if (
            client !== senderWs &&
            client.readyState === WebSocket.OPEN &&
            client.server === serverName &&
            client.map === map &&
            client.cell === cell
        ) {
            client.send(offlinePayload);
        }
    }
}

// Heartbeat berkala (setiap 25 detik) agar koneksi WebSocket melalui Cloudflare Proxy tidak pernah timeout
const interval = setInterval(() => {
    for (const ws of wss.clients) {
        if (!ws.isAlive) {
            console.log(`[Heartbeat Timeout] Terminating inactive client: ${ws.username || 'Unknown'}`);
            return ws.terminate();
        }
        ws.isAlive = false;
        ws.ping();
    }
}, 25000);

wss.on('close', () => {
    clearInterval(interval);
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`[OK] Server listening on http://0.0.0.0:${PORT}`);
    console.log(`[OK] Ready to receive WSS connections behind Cloudflare / Reverse Proxy!`);
});

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using Grimoire.Game;
using Grimoire.Networking;
using Grimoire.UI;
using NAudio.Wave;
using Concentus.Enums;
using Concentus.Structs;

namespace Grimoire.Tools
{
    public class VoiceChatManager
    {
        private static VoiceChatManager _instance;
        public static VoiceChatManager Instance => _instance ?? (_instance = new VoiceChatManager());

        // WebSocket Relay configuration (Cloudflare WSS friendly - hides VPS IP)
        public static readonly string DefaultEncryptedServer = "MAEaV2xAEgoRNQoOEQxfHkFXLBsLQy4WSgwc";
        public string serverUrl = DecryptString(DefaultEncryptedServer);
        public bool useWebSocket = true;

        public static string DecryptString(string base64)
        {
            try
            {
                byte[] data = Convert.FromBase64String(base64);
                byte[] key = Encoding.UTF8.GetBytes("GrimCodexVoice2026");
                for (int i = 0; i < data.Length; i++)
                {
                    data[i] = (byte)(data[i] ^ key[i % key.Length]);
                }
                return Encoding.UTF8.GetString(data);
            }
            catch
            {
                return "";
            }
        }

        private ClientWebSocket wsClient;
        private readonly SemaphoreSlim wsSendLock = new SemaphoreSlim(1, 1);
        private CancellationTokenSource wsCts;
        private bool isWsRunning = false;
        public bool isWsConnected = false;
        public string lastWsError = "None";

        // Network configurations (Legacy Raw UDP/TCP)
        public string signalingServerIP = DecryptIP("nlthojthhbthjc");
        public int signalingServerPort = 7030;
        public int localPort = 5055;
        public string myPublicIP = "";

        private static string DecryptIP(string obfuscated)
        {
            char[] chars = obfuscated.ToCharArray();
            for (int i = 0; i < chars.Length; i++)
            {
                chars[i] = (char)(chars[i] ^ 90);
            }
            return new string(chars);
        }
        
        public bool useExternalSignaling = true;
        public bool voiceEnabled = false;
        public bool isMuted = false;
        public bool isDeafened = false;
        public bool isLoopback = false;
        public float voiceVolume = 1.0f;
        public float voiceBoost = 1.0f;
        public int selectedMicIndex = 0;

        private bool cachedIsLoggedIn = false;
        private string cachedUsername = "";

        // Status variables
        public string connectionStatus = "Disconnected";
        public int udpPacketsSent = 0;
        public int udpPacketsReceived = 0;
        public string lastUdpError = "None";
        public string lastTcpError = "None";
        public string lastStunError = "None";
        public float micLevel = 0f;

        // UDP socket and endpoints
        private UdpClient udpClient;
        private IPEndPoint publicEP;
        private IPEndPoint signalingServerEP;

        // Thread control
        public bool isRunning = false;

        // TCP signaling state
        private TcpClient tcpClient;
        private NetworkStream tcpStream;
        private readonly object tcpLock = new object();
        private bool isTcpRunning = false;
        private bool isTcpConnected = false;

        // Audio codecs
        private OpusEncoder encoder;
        private OpusDecoder loopbackDecoder;
        private int sampleRate = 48000;
        private int channels = 2; // Stereo (2 channels)
        private int micChannels = 2;
        private int frameSize = 960; // 20ms at 48000Hz per channel

        // Mic input
        private WaveInEvent waveIn;
        private List<short> recordBuffer = new List<short>();

        // Audio output (loopback)
        private BufferedWaveProvider loopbackProvider;
        private WaveOutEvent loopbackOut;

        // Reusable microphone and local loopback buffers for Stereo (960 * 2 = 1920 samples)
        private short[] micSamplesBuffer = new short[1920];
        private short[] micFrameBuffer = new short[1920];
        private byte[] localCompBuffer = new byte[2048];
        private short[] localLoopbackOutBuffer = new short[1920];
        private byte[] localLoopbackByteBuffer = new byte[3840];
        private byte[] sendPacketBuffer = new byte[4096];
        private byte[] cachedUsernameBytes;
        private string lastUsernameForCache = "";

        private byte[] GetCachedUsernameBytes()
        {
            string currentUsername = cachedUsername;
            if (currentUsername != lastUsernameForCache || cachedUsernameBytes == null)
            {
                lastUsernameForCache = currentUsername;
                cachedUsernameBytes = Encoding.UTF8.GetBytes(currentUsername);
            }
            return cachedUsernameBytes;
        }

        // Peer mapping
        private Dictionary<string, RemotePeer> activePeers = new Dictionary<string, RemotePeer>(StringComparer.OrdinalIgnoreCase);
        private Dictionary<string, string> peerCells = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        private readonly object peersLock = new object();

        public string CurrentCell => lastCellName;

        public string GetPeerCell(string username)
        {
            lock (peersLock)
            {
                return peerCells.TryGetValue(username, out string cell) ? cell : null;
            }
        }

        // UI update timer
        private System.Windows.Forms.Timer uiTimer;
        private float presenceBroadcastTimer = 0f;
        private float keepAliveTimer = 0f;
        private string lastServerName = "";
        private string lastMapName = "";
        private string lastCellName = "";

        private string GetCurrentGameServer()
        {
            string server = Proxy.Instance?.ServerAddress ?? "";
            if (string.IsNullOrEmpty(server))
            {
                try
                {
                    server = Flash.Call<string>("RealAddress", new string[0]) ?? "";
                }
                catch {}
            }
            return server;
        }

        private VoiceChatManager()
        {
            // Initialize Opus Encoder/Decoder for loopback (Stereo)
            encoder = new OpusEncoder(sampleRate, channels, OpusApplication.OPUS_APPLICATION_VOIP);
            loopbackDecoder = new OpusDecoder(sampleRate, channels);
            
            // Load saved volume and boost settings
            try
            {
                string savedVol = Botting.Config.Instance?.Get("CodexVoice_Volume");
                if (!string.IsNullOrEmpty(savedVol) && float.TryParse(savedVol, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out float v))
                {
                    voiceVolume = Math.Max(0f, Math.Min(2.0f, v));
                }
                string savedBoost = Botting.Config.Instance?.Get("CodexVoice_Boost");
                if (!string.IsNullOrEmpty(savedBoost) && float.TryParse(savedBoost, System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out float b))
                {
                    voiceBoost = Math.Max(0f, Math.Min(3.0f, b));
                }
            }
            catch {}

            // Default endpoint for VPS signaling
            try
            {
                signalingServerEP = new IPEndPoint(IPAddress.Parse(signalingServerIP), signalingServerPort);
            }
            catch {}
        }

        public void StartVoice()
        {
            if (isRunning) StopVoice();

            try
            {
                cachedIsLoggedIn = Player.IsLoggedIn;
                cachedUsername = Player.Username ?? "";
            }
            catch
            {
                cachedIsLoggedIn = false;
                cachedUsername = "";
            }
            
            isRunning = true;
            connectionStatus = "Initializing...";

            if (useWebSocket)
            {
                isWsRunning = true;
                wsCts = new CancellationTokenSource();
                Task.Run(() => WebSocketRunLoopAsync(wsCts.Token));

                StartMicrophone();
                if (isLoopback)
                {
                    StartLoopbackAudio();
                }
                StartUpdateLoop();
                return;
            }
            
            // Start UDP Socket
            try
            {
                udpClient = new UdpClient(0); // Bind to dynamic local port
                localPort = ((IPEndPoint)udpClient.Client.LocalEndPoint).Port;
                udpClient.Client.ReceiveTimeout = 1000;
                udpClient.Client.SendTimeout = 1000;
            }
            catch (Exception ex)
            {
                connectionStatus = "UDP Init Failed: " + ex.Message;
                isRunning = false;
                return;
            }

            // Register proxy packet interceptor
            Proxy.Instance.ReceivedFromServer += OnReceivedFromServer;

            // Start STUN query in background thread
            Task.Run(() =>
            {
                try
                {
                    if (useExternalSignaling)
                    {
                        try
                        {
                            IPAddress[] ips = Dns.GetHostAddresses(signalingServerIP);
                            IPAddress targetIP = IPAddress.Loopback;
                            foreach (var ip in ips)
                            {
                                if (ip.AddressFamily == AddressFamily.InterNetwork)
                                {
                                    targetIP = ip;
                                    break;
                                }
                            }
                            signalingServerEP = new IPEndPoint(targetIP, signalingServerPort);
                        }
                        catch (Exception dnsEx)
                        {
                            Console.WriteLine("[CodexVoice] Failed to resolve signaling server DNS: " + dnsEx.Message);
                            throw;
                        }
                    }

                    publicEP = GetPublicIPWithSocket(udpClient);
                    if (publicEP != null)
                    {
                        myPublicIP = publicEP.Address.ToString();
                        connectionStatus = "Ready";
                    }
                    else
                    {
                        myPublicIP = "127.0.0.1";
                        publicEP = new IPEndPoint(IPAddress.Loopback, localPort);
                        connectionStatus = "Ready";
                    }
                }
                catch
                {
                    myPublicIP = "127.0.0.1";
                    publicEP = new IPEndPoint(IPAddress.Loopback, localPort);
                    connectionStatus = "Ready";
                }

                // Start UDP Receive Thread
                Task.Run(() => ReceiveLoop());

                // Start TCP VPS Signaling Thread if enabled
                if (useExternalSignaling)
                {
                    StartTcpSignaling();
                }
                else
                {
                    // P2P Chat-based: Broadcast our presence to the map room
                    BroadcastPresence(true);
                }
                
                // Start Microphone
                StartMicrophone();

                // Start Loopback audio if enabled
                if (isLoopback)
                {
                    StartLoopbackAudio();
                }

                // Start the UI Timer
                StartUpdateLoop();
            });
        }

        public void StopVoice()
        {
            if (!isRunning) return;

            isRunning = false;
            connectionStatus = "Disconnected";

            if (useWebSocket)
            {
                isWsRunning = false;
                isWsConnected = false;
                if (wsCts != null)
                {
                    try { wsCts.Cancel(); } catch {}
                    wsCts = null;
                }
                if (wsClient != null)
                {
                    try { wsClient.Abort(); wsClient.Dispose(); } catch {}
                    wsClient = null;
                }
            }

            // Stop updates
            StopUpdateLoop();

            // Broadcast offline status
            try
            {
                BroadcastPresence(false);
            }
            catch {}

            // Unsubscribe proxy event
            try
            {
                Proxy.Instance.ReceivedFromServer -= OnReceivedFromServer;
            }
            catch {}

            // Stop TCP signaling
            StopTcpSignaling();

            // Stop Microphone
            StopMicrophone();

            // Stop Loopback Output
            StopLoopbackAudio();

            // Dispose UDP Client
            if (udpClient != null)
            {
                try { udpClient.Close(); } catch {}
                udpClient = null;
            }

            // Dispose Peers
            lock (peersLock)
            {
                foreach (var peer in activePeers.Values)
                {
                    peer.Dispose();
                }
                activePeers.Clear();
            }
        }

        private void StartUpdateLoop()
        {
            if (Root.Instance.InvokeRequired)
            {
                Root.Instance.Invoke(new Action(StartUpdateLoop));
                return;
            }
            
            uiTimer = new System.Windows.Forms.Timer();
            uiTimer.Interval = 1000;
            uiTimer.Tick += OnUiTimerTick;
            uiTimer.Start();
        }

        private void StopUpdateLoop()
        {
            if (Root.Instance.InvokeRequired)
            {
                Root.Instance.Invoke(new Action(StopUpdateLoop));
                return;
            }
            
            if (uiTimer != null)
            {
                uiTimer.Stop();
                uiTimer.Dispose();
                uiTimer = null;
            }
        }

        private void OnUiTimerTick(object sender, EventArgs e)
        {
            if (!isRunning) return;

            try
            {
                cachedIsLoggedIn = Player.IsLoggedIn;
                cachedUsername = Player.Username ?? "";
            }
            catch {}

            // Decay VU meter
            if (micLevel > 0f)
            {
                micLevel -= 0.2f;
                if (micLevel < 0f) micLevel = 0f;
            }

            if (!voiceEnabled) return;

            // 0. Game Server changed check
            string currentServer = GetCurrentGameServer();
            if (currentServer != lastServerName && !string.IsNullOrEmpty(currentServer))
            {
                string oldServer = lastServerName;
                lastServerName = currentServer;
                Console.WriteLine($"[CodexVoice] Server changed from '{oldServer}' to '{currentServer}'. Re-syncing voice...");
                lock (peersLock)
                {
                    foreach (var peer in activePeers.Values)
                    {
                        peer.Dispose();
                    }
                    activePeers.Clear();
                }
                BroadcastPresence(true);
            }

            // 1. Map changed check
            string currentMap = Player.Map;
            if (currentMap != lastMapName && !string.IsNullOrEmpty(currentMap))
            {
                string oldMap = lastMapName;
                lastMapName = currentMap;
                Console.WriteLine($"[CodexVoice] Map changed from '{oldMap}' to '{currentMap}'. Re-syncing voice...");
                lock (peersLock)
                {
                    foreach (var peer in activePeers.Values)
                    {
                        peer.Dispose();
                    }
                    activePeers.Clear();
                }
                BroadcastPresence(true);
            }

            // 2. Cell changed check
            string currentCell = Player.Cell;
            if (currentCell != lastCellName && !string.IsNullOrEmpty(currentCell))
            {
                string oldCell = lastCellName;
                lastCellName = currentCell;
                Console.WriteLine($"[CodexVoice] Cell changed from '{oldCell}' to '{currentCell}'. Re-syncing voice...");
                lock (peersLock)
                {
                    foreach (var peer in activePeers.Values)
                    {
                        peer.Dispose();
                    }
                    activePeers.Clear();
                }
                BroadcastPresence(true);
            }

            // 3. Periodic presence broadcast (every 15 seconds)
            presenceBroadcastTimer += 1.0f;
            if (presenceBroadcastTimer >= 15.0f)
            {
                presenceBroadcastTimer = 0f;
                BroadcastPresence(true);
            }

            // 4. Periodic keepalive (every 1 second)
            keepAliveTimer += 1.0f;
            if (keepAliveTimer >= 1.0f)
            {
                keepAliveTimer = 0f;
                SendKeepAliveToPeers();
            }

            // 5. Update cached cells of active peers (only in P2P mode to avoid unnecessary Flash COM calls)
            if (!useExternalSignaling && !useWebSocket)
            {
                UpdatePeerCells();
            }

            // 6. Validate peers: remove peers not in the same cell or timed out
            ValidatePeers();
        }

        private void StartMicrophone()
        {
            try
            {
                if (WaveInEvent.DeviceCount == 0)
                {
                    Console.WriteLine("[CodexVoice] No microphone devices found.");
                    return;
                }
                
                try
                {
                    waveIn = new WaveInEvent();
                    waveIn.DeviceNumber = selectedMicIndex;
                    waveIn.WaveFormat = new WaveFormat(sampleRate, 16, 2);
                    waveIn.BufferMilliseconds = 20; // 20ms frame
                    waveIn.DataAvailable += OnMicrophoneDataAvailable;
                    waveIn.StartRecording();
                    micChannels = 2;
                }
                catch
                {
                    // Fallback to mono recording if hardware does not support stereo capture
                    waveIn = new WaveInEvent();
                    waveIn.DeviceNumber = selectedMicIndex;
                    waveIn.WaveFormat = new WaveFormat(sampleRate, 16, 1);
                    waveIn.BufferMilliseconds = 20;
                    waveIn.DataAvailable += OnMicrophoneDataAvailable;
                    waveIn.StartRecording();
                    micChannels = 1;
                }
                
                Console.WriteLine($"[CodexVoice] Recording started using mic index: {selectedMicIndex} (Hardware Channels: {micChannels})");
            }
            catch (Exception ex)
            {
                Console.WriteLine("[CodexVoice] Failed to start microphone: " + ex.Message);
            }
        }

        private void StopMicrophone()
        {
            try
            {
                if (waveIn != null)
                {
                    waveIn.DataAvailable -= OnMicrophoneDataAvailable;
                    waveIn.StopRecording();
                    waveIn.Dispose();
                    waveIn = null;
                }
            }
            catch {}
        }

        private void OnMicrophoneDataAvailable(object sender, WaveInEventArgs e)
        {
            if (!voiceEnabled || !isRunning || isMuted || isDeafened)
            {
                micLevel = 0f;
                return;
            }

            int sampleCount = e.BytesRecorded / 2;
            if (micSamplesBuffer == null || micSamplesBuffer.Length < sampleCount)
            {
                micSamplesBuffer = new short[sampleCount];
            }
            Buffer.BlockCopy(e.Buffer, 0, micSamplesBuffer, 0, e.BytesRecorded);

            lock (recordBuffer)
            {
                if (micChannels == 1)
                {
                    // Duplicate mono samples to Stereo (L, R)
                    for (int i = 0; i < sampleCount; i++)
                    {
                        recordBuffer.Add(micSamplesBuffer[i]);
                        recordBuffer.Add(micSamplesBuffer[i]);
                    }
                }
                else
                {
                    for (int i = 0; i < sampleCount; i++)
                    {
                        recordBuffer.Add(micSamplesBuffer[i]);
                    }
                }

                int targetSamples = frameSize * channels; // 960 * 2 = 1920
                while (recordBuffer.Count >= targetSamples)
                {
                    if (micFrameBuffer == null || micFrameBuffer.Length < targetSamples)
                    {
                        micFrameBuffer = new short[targetSamples];
                    }
                    recordBuffer.CopyTo(0, micFrameBuffer, 0, targetSamples);
                    recordBuffer.RemoveRange(0, targetSamples);

                    ProcessAndSendLocalFrame(micFrameBuffer);
                }
            }
        }

        private void ProcessAndSendLocalFrame(short[] frame)
        {
            // Apply input boost & calculate mic level
            float boost = voiceBoost;
            float peak = 0f;
            int totalSamples = frameSize * channels; // 1920

            for (int i = 0; i < totalSamples; i++)
            {
                float sampleVal = (frame[i] / 32767f) * boost;
                sampleVal = Math.Min(1.0f, Math.Max(-1.0f, sampleVal));
                frame[i] = (short)(sampleVal * 32767f);

                float absVal = Math.Abs(sampleVal);
                if (absVal > peak) peak = absVal;
            }
            micLevel = peak;

            // Encode (Opus frame_size is samples per channel = 960)
            if (localCompBuffer == null)
            {
                localCompBuffer = new byte[2048];
            }
            int encLen = encoder.Encode(frame, 0, frameSize, localCompBuffer, 0, localCompBuffer.Length);

            if (encLen > 0)
            {
                // Send to peers
                SendAudioToPeers(localCompBuffer, encLen);

                // Loopback
                if (isLoopback && loopbackProvider != null)
                {
                    try
                    {
                        if (localLoopbackOutBuffer == null || localLoopbackOutBuffer.Length < totalSamples)
                        {
                            localLoopbackOutBuffer = new short[totalSamples];
                        }
                        int decodedSamples = loopbackDecoder.Decode(localCompBuffer, 0, encLen, localLoopbackOutBuffer, 0, frameSize, false);
                        if (decodedSamples > 0)
                        {
                            int byteCount = decodedSamples * channels * 2;
                            if (localLoopbackByteBuffer == null || localLoopbackByteBuffer.Length < byteCount)
                            {
                                localLoopbackByteBuffer = new byte[byteCount];
                            }
                            Buffer.BlockCopy(localLoopbackOutBuffer, 0, localLoopbackByteBuffer, 0, byteCount);
                            loopbackProvider.AddSamples(localLoopbackByteBuffer, 0, byteCount);
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("[CodexVoice] Loopback decode failed: " + ex.Message);
                    }
                }
            }
        }

        private void StartLoopbackAudio()
        {
            StopLoopbackAudio();
            try
            {
                loopbackProvider = new BufferedWaveProvider(new WaveFormat(sampleRate, 16, channels));
                loopbackProvider.DiscardOnBufferOverflow = true;
                loopbackProvider.BufferDuration = TimeSpan.FromSeconds(5);

                loopbackOut = new WaveOutEvent();
                loopbackOut.Init(loopbackProvider);
                loopbackOut.Play();
            }
            catch {}
        }

        private void StopLoopbackAudio()
        {
            try
            {
                if (loopbackOut != null)
                {
                    loopbackOut.Stop();
                    loopbackOut.Dispose();
                    loopbackOut = null;
                }
                loopbackProvider = null;
            }
            catch {}
        }

        public void SetLoopback(bool enabled)
        {
            isLoopback = enabled;
            if (enabled && isRunning)
            {
                StartLoopbackAudio();
            }
            else
            {
                StopLoopbackAudio();
            }
        }

        private void SendAudioToPeers(byte[] data, int dataLen)
        {
            if (useWebSocket)
            {
                if (!cachedIsLoggedIn || wsClient == null || wsClient.State != WebSocketState.Open) return;
                try
                {
                    byte[] nameBytes = GetCachedUsernameBytes();
                    int totalLength = 1 + nameBytes.Length + dataLen;
                    if (sendPacketBuffer == null || sendPacketBuffer.Length < totalLength)
                    {
                        sendPacketBuffer = new byte[totalLength * 2];
                    }
                    sendPacketBuffer[0] = (byte)nameBytes.Length;
                    Array.Copy(nameBytes, 0, sendPacketBuffer, 1, nameBytes.Length);
                    Array.Copy(data, 0, sendPacketBuffer, 1 + nameBytes.Length, dataLen);

                    _ = SendWebSocketBinaryAsync(sendPacketBuffer, totalLength);
                    udpPacketsSent++;
                }
                catch (Exception ex)
                {
                    lastWsError = "SendAudio: " + ex.Message;
                }
                return;
            }

            if (useExternalSignaling)
            {
                if (!cachedIsLoggedIn || signalingServerEP == null || udpClient == null) return;
                try
                {
                    byte[] nameBytes = GetCachedUsernameBytes();
                    int totalLength = 1 + nameBytes.Length + dataLen;
                    if (sendPacketBuffer == null || sendPacketBuffer.Length < totalLength)
                    {
                        sendPacketBuffer = new byte[totalLength * 2];
                    }
                    sendPacketBuffer[0] = (byte)nameBytes.Length;
                    Array.Copy(nameBytes, 0, sendPacketBuffer, 1, nameBytes.Length);
                    Array.Copy(data, 0, sendPacketBuffer, 1 + nameBytes.Length, dataLen);

                    udpClient.Send(sendPacketBuffer, totalLength, signalingServerEP);
                    udpPacketsSent++;
                }
                catch (Exception ex)
                {
                    lastUdpError = "SendAudio: " + ex.Message;
                }
                return;
            }

            lock (peersLock)
            {
                if (activePeers.Count == 0 || udpClient == null) return;

                foreach (var peer in activePeers.Values)
                {
                    if (peer.endpoint != null)
                    {
                        try
                        {
                            udpClient.Send(data, dataLen, peer.endpoint);
                            udpPacketsSent++;
                        }
                        catch (Exception ex)
                        {
                            lastUdpError = "SendAudioP2P: " + ex.Message;
                        }
                    }
                }
            }
        }

        private void SendKeepAliveToPeers()
        {
            if (useExternalSignaling)
            {
                if (!cachedIsLoggedIn || signalingServerEP == null || udpClient == null) return;
                try
                {
                    byte[] nameBytes = Encoding.UTF8.GetBytes(cachedUsername);
                    byte[] packet = new byte[1 + nameBytes.Length + 1];
                    packet[0] = (byte)nameBytes.Length;
                    Array.Copy(nameBytes, 0, packet, 1, nameBytes.Length);
                    packet[packet.Length - 1] = 0; // 1-byte keep-alive payload

                    udpClient.Send(packet, packet.Length, signalingServerEP);
                    udpPacketsSent++;
                }
                catch (Exception ex)
                {
                    lastUdpError = "SendKeepAlive: " + ex.Message;
                }
                return;
            }

            lock (peersLock)
            {
                if (activePeers.Count == 0 || udpClient == null) return;
                byte[] keepAliveData = new byte[] { 0 };
                foreach (var peer in activePeers.Values)
                {
                    if (peer.endpoint != null)
                    {
                        try
                        {
                            udpClient.Send(keepAliveData, keepAliveData.Length, peer.endpoint);
                            udpPacketsSent++;
                        }
                        catch (Exception ex)
                        {
                            lastUdpError = "SendKeepAliveP2P: " + ex.Message;
                        }
                    }
                }
            }
        }

        private void ReceiveLoop()
        {
            IPEndPoint remoteEP = new IPEndPoint(IPAddress.Any, 0);
            while (isRunning)
            {
                try
                {
                    byte[] packet = udpClient.Receive(ref remoteEP);
                    udpPacketsReceived++;
                    if (packet == null || packet.Length == 0) continue;
                    if (isDeafened) continue;

                    if (useExternalSignaling)
                    {
                        if (signalingServerEP != null && remoteEP.Address.Equals(signalingServerEP.Address))
                        {
                            if (packet.Length < 2) continue;
                            int nameLen = packet[0];
                            if (packet.Length < 1 + nameLen) continue;

                            string senderName = Encoding.UTF8.GetString(packet, 1, nameLen);
                            int payloadLen = packet.Length - 1 - nameLen;
                            if (payloadLen < 1) continue;

                            lock (peersLock)
                            {
                                if (!activePeers.TryGetValue(senderName, out var peer))
                                {
                                    IPEndPoint dummyEP = new IPEndPoint(IPAddress.Loopback, 0);
                                    peer = new RemotePeer(senderName, dummyEP, sampleRate, frameSize);
                                    activePeers[senderName] = peer;
                                    Console.WriteLine("[CodexVoice] Automatically mapped remote peer via VPS UDP: " + senderName);
                                }
                                peer.lastSeen = DateTime.UtcNow;

                                if (payloadLen > 1)
                                {
                                    peer.FeedAudio(packet, 1 + nameLen, payloadLen);
                                }
                            }
                        }
                    }
                    else
                    {
                        lock (peersLock)
                        {
                            foreach (var peer in activePeers.Values)
                            {
                                if (peer.endpoint.Equals(remoteEP))
                                {
                                    peer.lastSeen = DateTime.UtcNow;
                                    if (packet.Length > 4)
                                    {
                                        peer.FeedAudio(packet, 0, packet.Length);
                                    }
                                    break;
                                }
                                else if (!IsPrivateIP(remoteEP.Address) && peer.endpoint.Address.Equals(remoteEP.Address))
                                {
                                    Console.WriteLine($"[CodexVoice] Symmetric NAT detected for {peer.username}. Updating P2P port from {peer.endpoint.Port} to {remoteEP.Port}");
                                    peer.endpoint = remoteEP;
                                    peer.lastSeen = DateTime.UtcNow;
                                    if (packet.Length > 4)
                                    {
                                        peer.FeedAudio(packet, 0, packet.Length);
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                catch (SocketException)
                {
                    // Handle close/abort socket cleanly
                }
                catch (Exception ex)
                {
                    lastUdpError = "Receive: " + ex.Message;
                    Console.WriteLine("[CodexVoice] Receive error: " + ex.Message);
                }
            }
        }

        public void BroadcastPresence(bool online)
        {
            if (useWebSocket)
            {
                if (online)
                {
                    SendWsPresenceUpdate();
                }
                return;
            }

            if (useExternalSignaling)
            {
                if (online)
                {
                    SendTcpPresenceUpdate();
                }
                else
                {
                    StopTcpSignaling();
                }
                return;
            }

            if (!Player.IsLoggedIn || publicEP == null) return;

            string msg;
            if (online)
            {
                string localIP = GetLocalIPAddress();
                string rawData = $"{publicEP.Address}:{publicEP.Port}|{localIP}:{localPort}";
                string encryptedData = EncryptData(rawData);
                msg = $"[CodexVoicePing:{encryptedData}]";
            }
            else
            {
                msg = "[CodexVoiceDisconnect]";
            }

            // Send immediately to the zone chat
            _ = Proxy.Instance.SendToServer($"%xt%zm%message%1%{msg}%zone%");
        }

        private void SendReply(string targetUser)
        {
            if (useExternalSignaling) return;

            if (!Player.IsLoggedIn || publicEP == null) return;
            
            string localIP = GetLocalIPAddress();
            string rawData = $"{publicEP.Address}:{publicEP.Port}|{localIP}:{localPort}";
            string encryptedData = EncryptData(rawData);
            string msg = $"[CodexVoiceReply:{encryptedData}]";
            
            // Whisper to target user
            _ = Proxy.Instance.SendToServer($"%xt%zm%message%1%{msg}%whisper%{targetUser}%");
        }

        public void HandleIncomingChat(string senderName, string msgText)
        {
            if (string.IsNullOrEmpty(senderName) || string.IsNullOrEmpty(msgText)) return;

            bool isVoiceSignal = msgText.Contains("[CodexVoicePing:") || 
                                 msgText.Contains("[CodexVoiceReply:") || 
                                 msgText.Contains("[CodexVoiceDisconnect]");

            if (!isVoiceSignal) return;

            if (useExternalSignaling) return;

            if (Player.IsLoggedIn && senderName.Equals(Player.Username, StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            // 1. Peer is pinging the entire room
            if (msgText.Contains("[CodexVoicePing:"))
            {
                if (!voiceEnabled || !isRunning) return;

                try
                {
                    // Verify they are in the same cell as us
                    World.RefreshDictionary();
                    PlayerInfo peerInfo = World.Players.FirstOrDefault(p => p.Name.Equals(senderName, StringComparison.OrdinalIgnoreCase));
                    if (peerInfo == null || peerInfo.Cell != Player.Cell)
                    {
                        return; // Discard ping if not in same cell
                    }

                    // Extract and decrypt payload
                    int startIndex = msgText.IndexOf("[CodexVoicePing:");
                    int endIndex = msgText.IndexOf("]", startIndex);
                    string encryptedData = msgText.Substring(startIndex, endIndex - startIndex).Replace("[CodexVoicePing:", "");
                    
                    string data = DecryptData(encryptedData);
                    if (string.IsNullOrEmpty(data)) return;
                    
                    string[] parts = data.Split('|');
                    if (parts.Length == 2)
                    {
                        string[] pubParts = parts[0].Split(':');
                        string[] locParts = parts[1].Split(':');

                        if (pubParts.Length == 2 && locParts.Length == 2)
                        {
                            string pubIP = pubParts[0];
                            int pubPort = int.Parse(pubParts[1]);
                            string locIP = locParts[0];
                            int locPort = int.Parse(locParts[1]);

                            IPEndPoint peerEP;
                            if (pubIP == myPublicIP && myPublicIP != "127.0.0.1" && myPublicIP != "")
                            {
                                peerEP = new IPEndPoint(IPAddress.Parse(locIP), locPort);
                            }
                            else
                            {
                                peerEP = new IPEndPoint(IPAddress.Parse(pubIP), pubPort);
                            }

                            AddOrUpdatePeer(senderName, peerEP);

                            // Reply back to let them know we are also active
                            SendReply(senderName);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("[CodexVoice] Failed to parse VoicePing: " + ex.Message);
                }
            }

            // 2. Peer is replying to our ping
            if (msgText.Contains("[CodexVoiceReply:"))
            {
                if (!voiceEnabled || !isRunning) return;

                try
                {
                    // Verify they are in the same cell as us
                    World.RefreshDictionary();
                    PlayerInfo peerInfo = World.Players.FirstOrDefault(p => p.Name.Equals(senderName, StringComparison.OrdinalIgnoreCase));
                    if (peerInfo == null || peerInfo.Cell != Player.Cell)
                    {
                        return; // Discard reply if not in same cell
                    }

                    // Extract and decrypt payload
                    int startIndex = msgText.IndexOf("[CodexVoiceReply:");
                    int endIndex = msgText.IndexOf("]", startIndex);
                    string encryptedData = msgText.Substring(startIndex, endIndex - startIndex).Replace("[CodexVoiceReply:", "");
                    
                    string data = DecryptData(encryptedData);
                    if (string.IsNullOrEmpty(data)) return;
                    
                    string[] parts = data.Split('|');
                    if (parts.Length == 2)
                    {
                        string[] pubParts = parts[0].Split(':');
                        string[] locParts = parts[1].Split(':');

                        if (pubParts.Length == 2 && locParts.Length == 2)
                        {
                            string pubIP = pubParts[0];
                            int pubPort = int.Parse(pubParts[1]);
                            string locIP = locParts[0];
                            int locPort = int.Parse(locParts[1]);

                            IPEndPoint peerEP;
                            if (pubIP == myPublicIP && myPublicIP != "127.0.0.1" && myPublicIP != "")
                            {
                                peerEP = new IPEndPoint(IPAddress.Parse(locIP), locPort);
                            }
                            else
                            {
                                peerEP = new IPEndPoint(IPAddress.Parse(pubIP), pubPort);
                            }

                            AddOrUpdatePeer(senderName, peerEP);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("[CodexVoice] Failed to parse VoiceReply: " + ex.Message);
                }
            }

            // 3. Peer is disconnecting
            if (msgText.Contains("[CodexVoiceDisconnect]"))
            {
                lock (peersLock)
                {
                    if (activePeers.TryGetValue(senderName, out var peer))
                    {
                        peer.Dispose();
                        activePeers.Remove(senderName);
                        Console.WriteLine("[CodexVoice] Peer disconnected manually: " + senderName);
                    }
                }
            }
        }

        private void ValidatePeers()
        {
            if (!cachedIsLoggedIn) return;

            lock (peersLock)
            {
                if (activePeers.Count == 0) return;
            }

            List<string> peersToRemove = new List<string>();
            string currentCell = lastCellName;

            lock (peersLock)
            {
                foreach (var peer in activePeers)
                {
                    if (useExternalSignaling || useWebSocket)
                    {
                        // Timeout clean-up: if no packets (keep-alive or voice) received for 10 seconds, consider disconnected
                        if ((DateTime.UtcNow - peer.Value.lastSeen).TotalSeconds > 10)
                        {
                            peersToRemove.Add(peer.Key);
                        }
                    }
                    else
                    {
                        if (peerCells.TryGetValue(peer.Key, out string peerCell))
                        {
                            if (string.IsNullOrEmpty(peerCell) || peerCell != currentCell)
                            {
                                peersToRemove.Add(peer.Key);
                            }
                        }
                        else
                        {
                            peersToRemove.Add(peer.Key);
                        }
                    }
                }

                foreach (var name in peersToRemove)
                {
                    if (activePeers.TryGetValue(name, out var peer))
                    {
                        peer.Dispose();
                        activePeers.Remove(name);
                        peerCells.Remove(name);
                        Console.WriteLine("[CodexVoice] Peer timed out or left cell: " + name);
                    }
                }
            }
        }

        private void UpdatePeerCells()
        {
            if (!cachedIsLoggedIn) return;

            lock (peersLock)
            {
                if (activePeers.Count == 0)
                {
                    peerCells.Clear();
                    return;
                }

                // Call the reliable SWF method to refresh the player list
                World.RefreshDictionary();

                // Clear obsolete peers from cache
                var keysToRemove = peerCells.Keys.Where(k => !activePeers.ContainsKey(k)).ToList();
                foreach (var k in keysToRemove)
                {
                    peerCells.Remove(k);
                }

                foreach (var peer in activePeers.Keys)
                {
                    PlayerInfo peerInfo = World.Players.FirstOrDefault(p => p.Name.Equals(peer, StringComparison.OrdinalIgnoreCase));
                    if (peerInfo != null)
                    {
                        peerCells[peer] = peerInfo.Cell;
                    }
                    else
                    {
                        peerCells[peer] = null;
                    }
                }
            }
        }

        #region WebSocket Implementation (Cloudflare WSS)
        private async Task WebSocketRunLoopAsync(CancellationToken ct)
        {
            while (isWsRunning && !ct.IsCancellationRequested)
            {
                try
                {
                    connectionStatus = "Connecting...";
                    ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

                    wsClient = new ClientWebSocket();
                    wsClient.Options.KeepAliveInterval = TimeSpan.FromSeconds(20);

                    Uri uri = new Uri(serverUrl);
                    await wsClient.ConnectAsync(uri, ct);

                    isWsConnected = true;
                    connectionStatus = "Connected";
                    lastWsError = "None";
                    Console.WriteLine("[CodexVoice] Connected to WebSocket voice relay: " + serverUrl);

                    SendWsPresenceUpdate();

                    byte[] buffer = new byte[8192];
                    while (isWsRunning && wsClient != null && wsClient.State == WebSocketState.Open && !ct.IsCancellationRequested)
                    {
                        var result = await wsClient.ReceiveAsync(new ArraySegment<byte>(buffer), ct);
                        if (result.MessageType == WebSocketMessageType.Close)
                        {
                            break;
                        }

                        if (result.MessageType == WebSocketMessageType.Binary)
                        {
                            udpPacketsReceived++;
                            if (isDeafened) continue;

                            int count = result.Count;
                            if (count < 2) continue;
                            int nameLen = buffer[0];
                            if (count < 1 + nameLen) continue;

                            string senderName = Encoding.UTF8.GetString(buffer, 1, nameLen);
                            int payloadLen = count - 1 - nameLen;
                            if (payloadLen <= 0) continue;

                            lock (peersLock)
                            {
                                if (!activePeers.TryGetValue(senderName, out var peer))
                                {
                                    peer = new RemotePeer(senderName, null, sampleRate, frameSize);
                                    activePeers[senderName] = peer;
                                    Console.WriteLine("[CodexVoice] Mapped peer via WebSocket: " + senderName);
                                }
                                peer.lastSeen = DateTime.UtcNow;
                                peer.FeedAudio(buffer, 1 + nameLen, payloadLen);
                            }
                        }
                        else if (result.MessageType == WebSocketMessageType.Text)
                        {
                            string text = Encoding.UTF8.GetString(buffer, 0, result.Count);
                            if (text.Contains("\"action\":\"offline\""))
                            {
                                string username = ExtractJsonValue(text, "username");
                                if (!string.IsNullOrEmpty(username))
                                {
                                    lock (peersLock)
                                    {
                                        if (activePeers.TryGetValue(username, out var peer))
                                        {
                                            peer.Dispose();
                                            activePeers.Remove(username);
                                            Console.WriteLine("[CodexVoice] Peer offline: " + username);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    if (!isWsRunning || ct.IsCancellationRequested) break;
                    isWsConnected = false;
                    lastWsError = ex.Message;
                    connectionStatus = "Reconnecting...";
                    Console.WriteLine($"[CodexVoice] WebSocket error: {ex.Message}. Reconnecting in 3s...");
                }
                finally
                {
                    isWsConnected = false;
                    if (wsClient != null)
                    {
                        try { wsClient.Abort(); wsClient.Dispose(); } catch {}
                        wsClient = null;
                    }
                }

                if (!isWsRunning || ct.IsCancellationRequested) break;
                try
                {
                    await Task.Delay(3000, ct);
                }
                catch
                {
                    break;
                }
            }
        }

        private async Task SendWebSocketBinaryAsync(byte[] buffer, int length)
        {
            if (wsClient == null || wsClient.State != WebSocketState.Open) return;
            if (!await wsSendLock.WaitAsync(100)) return;
            try
            {
                if (wsClient != null && wsClient.State == WebSocketState.Open)
                {
                    await wsClient.SendAsync(new ArraySegment<byte>(buffer, 0, length), WebSocketMessageType.Binary, true, CancellationToken.None);
                }
            }
            catch (Exception ex)
            {
                lastWsError = ex.Message;
            }
            finally
            {
                wsSendLock.Release();
            }
        }

        private async Task SendWebSocketTextMessageAsync(string json)
        {
            if (wsClient == null || wsClient.State != WebSocketState.Open) return;
            await wsSendLock.WaitAsync();
            try
            {
                if (wsClient != null && wsClient.State == WebSocketState.Open)
                {
                    byte[] bytes = Encoding.UTF8.GetBytes(json);
                    await wsClient.SendAsync(new ArraySegment<byte>(bytes, 0, bytes.Length), WebSocketMessageType.Text, true, CancellationToken.None);
                }
            }
            catch (Exception ex)
            {
                lastWsError = ex.Message;
            }
            finally
            {
                wsSendLock.Release();
            }
        }

        public void SendWsPresenceUpdate()
        {
            if (!isWsConnected || wsClient == null || wsClient.State != WebSocketState.Open || !cachedIsLoggedIn) return;
            try
            {
                string server = GetCurrentGameServer();
                string map = lastMapName ?? "";
                string cell = lastCellName ?? "";
                string json = $"{{\"action\":\"update\",\"username\":\"{cachedUsername}\",\"server\":\"{server}\",\"map\":\"{map}\",\"cell\":\"{cell}\"}}";
                _ = SendWebSocketTextMessageAsync(json);
            }
            catch (Exception ex)
            {
                Console.WriteLine("[CodexVoice] Failed to send WS presence update: " + ex.Message);
            }
        }
        #endregion

        private void StartTcpSignaling()
        {
            isTcpRunning = true;
            connectionStatus = "Connecting...";
            Task.Run(() => TcpReceiveLoop());
        }

        private void StopTcpSignaling()
        {
            isTcpRunning = false;
            isTcpConnected = false;
            connectionStatus = "Ready";
            lock (tcpLock)
            {
                if (tcpStream != null) { try { tcpStream.Close(); } catch {} tcpStream = null; }
                if (tcpClient != null) { try { tcpClient.Close(); } catch {} tcpClient = null; }
            }
        }

        private void TcpReceiveLoop()
        {
            while (isTcpRunning)
            {
                try
                {
                    connectionStatus = "Connecting...";
                    lock (tcpLock)
                    {
                        tcpClient = new TcpClient();
                    }

                    Console.WriteLine($"[CodexVoice] Connecting to signaling server at {signalingServerIP}:{signalingServerPort}...");
                    
                    var result = tcpClient.BeginConnect(signalingServerIP, signalingServerPort, null, null);
                    var success = result.AsyncWaitHandle.WaitOne(TimeSpan.FromSeconds(5));
                    if (!success)
                    {
                        throw new SocketException((int)SocketError.TimedOut);
                    }
                    tcpClient.EndConnect(result);

                    lock (tcpLock)
                    {
                        tcpStream = tcpClient.GetStream();
                    }

                    isTcpConnected = true;
                    connectionStatus = "Connected";
                    lastTcpError = "None";
                    Console.WriteLine("[CodexVoice] Connected to signaling server successfully.");

                    SendTcpPresenceUpdate();

                    byte[] buffer = new byte[4096];
                    StringBuilder sb = new StringBuilder();

                    while (isTcpRunning)
                    {
                        int readBytes = tcpStream.Read(buffer, 0, buffer.Length);
                        if (readBytes <= 0) break; // Disconnected

                        string chunk = Encoding.UTF8.GetString(buffer, 0, readBytes);
                        sb.Append(chunk);

                        string content = sb.ToString();
                        int newlineIdx = content.IndexOf('\n');
                        while (newlineIdx >= 0)
                        {
                            string line = content.Substring(0, newlineIdx).Trim();
                            content = content.Substring(newlineIdx + 1);
                            sb.Clear();
                            sb.Append(content);

                            if (!string.IsNullOrEmpty(line))
                            {
                                try
                                {
                                    ProcessTcpMessage(line);
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine("[CodexVoice] Error processing TCP message: " + ex.Message);
                                }
                            }

                            newlineIdx = content.IndexOf('\n');
                        }
                    }
                }
                catch (Exception ex)
                {
                    isTcpConnected = false;
                    lastTcpError = ex.Message;
                    Console.WriteLine($"[CodexVoice] Signaling connection error: {ex.Message}. Retrying in 5s...");
                }

                isTcpConnected = false;
                lock (tcpLock)
                {
                    if (tcpStream != null) { try { tcpStream.Close(); } catch {} tcpStream = null; }
                    if (tcpClient != null) { try { tcpClient.Close(); } catch {} tcpClient = null; }
                }

                for (int i = 0; i < 50 && isTcpRunning; i++)
                {
                    Thread.Sleep(100);
                }
            }
        }

        private void SendTcpPresenceUpdate()
        {
            if (!isTcpConnected || tcpStream == null || !cachedIsLoggedIn) return;

            try
            {
                string localIP = GetLocalIPAddress();
                string server = GetCurrentGameServer();
                string map = lastMapName ?? "";
                string cell = lastCellName ?? "";

                string json = "{" +
                    $"\"action\":\"update\"," +
                    $"\"username\":\"{cachedUsername}\"," +
                    $"\"server\":\"{server}\"," +
                    $"\"map\":\"{map}\"," +
                    $"\"cell\":\"{cell}\"," +
                    $"\"publicIP\":\"{myPublicIP}\"," +
                    $"\"publicPort\":{publicEP?.Port ?? localPort}," +
                    $"\"localIP\":\"{localIP}\"," +
                    $"\"localPort\":{localPort}" +
                    "}\n";

                byte[] data = Encoding.UTF8.GetBytes(json);
                lock (tcpLock)
                {
                    if (tcpStream != null)
                    {
                        tcpStream.Write(data, 0, data.Length);
                        tcpStream.Flush();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("[CodexVoice] Failed to send TCP presence update: " + ex.Message);
            }
        }

        private void ProcessTcpMessage(string line)
        {
            if (line.Contains("\"action\":\"online\""))
            {
                string username = ExtractJsonValue(line, "username");
                string pubIP = ExtractJsonValue(line, "publicIP");
                int pubPort = int.Parse(ExtractJsonValue(line, "publicPort"));
                string locIP = ExtractJsonValue(line, "localIP");
                int locPort = int.Parse(ExtractJsonValue(line, "localPort"));

                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(pubIP)) return;

                if (cachedIsLoggedIn && username.Equals(cachedUsername, StringComparison.OrdinalIgnoreCase)) return;

                IPEndPoint peerEP;
                if (pubIP == myPublicIP && myPublicIP != "127.0.0.1" && myPublicIP != "")
                {
                    peerEP = new IPEndPoint(IPAddress.Parse(locIP), locPort);
                }
                else
                {
                    peerEP = new IPEndPoint(IPAddress.Parse(pubIP), pubPort);
                }

                AddOrUpdatePeer(username, peerEP);
            }
            else if (line.Contains("\"action\":\"offline\""))
            {
                string username = ExtractJsonValue(line, "username");
                if (string.IsNullOrEmpty(username)) return;

                lock (peersLock)
                {
                    if (activePeers.TryGetValue(username, out var peer))
                    {
                        peer.Dispose();
                        activePeers.Remove(username);
                        Console.WriteLine("[CodexVoice] Peer disconnected via server: " + username);
                    }
                }
            }
        }

        private string ExtractJsonValue(string json, string key)
        {
            string pattern = $"\"{key}\":\"";
            int idx = json.IndexOf(pattern);
            if (idx >= 0)
            {
                int start = idx + pattern.Length;
                int end = json.IndexOf('"', start);
                if (end >= 0)
                {
                    return json.Substring(start, end - start);
                }
            }
            else
            {
                pattern = $"\"{key}\":";
                idx = json.IndexOf(pattern);
                if (idx >= 0)
                {
                    int start = idx + pattern.Length;
                    int end = start;
                    while (end < json.Length && (char.IsDigit(json[end]) || json[end] == '.' || json[end] == '-'))
                    {
                        end++;
                    }
                    if (end > start)
                    {
                        return json.Substring(start, end - start);
                    }
                }
            }
            return "";
        }

        private static IPEndPoint GetPublicIPWithSocket(UdpClient client)
        {
            string[] stunHosts = new string[]
            {
                "stun.l.google.com",
                "stun1.l.google.com",
                "stun.sipgate.net",
                "stun.voipbuster.com",
                "stun.xten.com"
            };

            foreach (var host in stunHosts)
            {
                try
                {
                    IPAddress[] ips = Dns.GetHostAddresses(host);
                    if (ips == null || ips.Length == 0) continue;
                    
                    IPAddress targetIP = null;
                    foreach (var ip in ips)
                    {
                        if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                        {
                            targetIP = ip;
                            break;
                        }
                    }
                    if (targetIP == null) continue;

                    IPEndPoint stunServer = new IPEndPoint(targetIP, 19302);

                    byte[] stunRequest = new byte[20];
                    stunRequest[0] = 0x00; stunRequest[1] = 0x01; // Binding Request
                    stunRequest[2] = 0x00; stunRequest[3] = 0x00; // Message Length
                    stunRequest[4] = 0x21; stunRequest[5] = 0x12; stunRequest[6] = 0xA4; stunRequest[7] = 0x42; // Magic Cookie
                    
                    int oldReceiveTimeout = client.Client.ReceiveTimeout;
                    int oldSendTimeout = client.Client.SendTimeout;
                    client.Client.ReceiveTimeout = 1500;
                    client.Client.SendTimeout = 1500;
                    
                    client.Send(stunRequest, stunRequest.Length, stunServer);
                    
                    IPEndPoint remoteEP = new IPEndPoint(IPAddress.Any, 0);
                    byte[] stunResponse = client.Receive(ref remoteEP);
                    
                    client.Client.ReceiveTimeout = oldReceiveTimeout;
                    client.Client.SendTimeout = oldSendTimeout;
                    
                    if (stunResponse != null && stunResponse.Length >= 20 && stunResponse[0] == 0x01 && stunResponse[1] == 0x01)
                    {
                        int i = 20;
                        while (i < stunResponse.Length)
                        {
                            int type = (stunResponse[i] << 8) | stunResponse[i + 1];
                            int length = (stunResponse[i + 2] << 8) | stunResponse[i + 3];
                            if (type == 0x0001 || type == 0x0020) // MAPPED-ADDRESS or XOR-MAPPED-ADDRESS
                            {
                                int family = stunResponse[i + 5];
                                int port = (stunResponse[i + 6] << 8) | stunResponse[i + 7];
                                if (type == 0x0020)
                                {
                                    port ^= 0x2112;
                                }
                                byte[] ipBytes = new byte[4];
                                if (type == 0x0020)
                                {
                                    ipBytes[0] = (byte)(stunResponse[i + 8] ^ 0x21);
                                    ipBytes[1] = (byte)(stunResponse[i + 9] ^ 0x12);
                                    ipBytes[2] = (byte)(stunResponse[i + 10] ^ 0xA4);
                                    ipBytes[3] = (byte)(stunResponse[i + 11] ^ 0x42);
                                }
                                else
                                {
                                    ipBytes[0] = stunResponse[i + 8];
                                    ipBytes[1] = stunResponse[i + 9];
                                    ipBytes[2] = stunResponse[i + 10];
                                    ipBytes[3] = stunResponse[i + 11];
                                }
                                return new IPEndPoint(new IPAddress(ipBytes), port);
                            }
                            i += 4 + length;
                        }
                    }
                }
                catch
                {
                    // Try next STUN server
                }
            }
            return null;
        }

        private string GetLocalIPAddress()
        {
            try
            {
                var host = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName());
                foreach (var ip in host.AddressList)
                {
                    if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                    {
                        string ipStr = ip.ToString();
                        if (ipStr != "127.0.0.1")
                        {
                            return ipStr;
                        }
                    }
                }
            }
            catch {}
            return "127.0.0.1";
        }

        private bool IsPrivateIP(IPAddress address)
        {
            if (IPAddress.IsLoopback(address)) return true;
            string ipStr = address.ToString();
            return ipStr.StartsWith("10.") || 
                   ipStr.StartsWith("192.168.") || 
                   ipStr.StartsWith("172.") || 
                   ipStr.StartsWith("169.254.");
        }

        private string EncryptData(string plainText)
        {
            try
            {
                byte[] bytes = System.Text.Encoding.UTF8.GetBytes(plainText);
                string key = "CodexVoiceShield2026";
                for (int i = 0; i < bytes.Length; i++)
                {
                    bytes[i] = (byte)(bytes[i] ^ key[i % key.Length]);
                }
                return Convert.ToBase64String(bytes)
                    .Replace('+', '-')
                    .Replace('/', '_')
                    .Replace("=", "");
            }
            catch
            {
                return plainText;
            }
        }

        private string DecryptData(string cipherText)
        {
            try
            {
                string base64 = cipherText.Replace('-', '+').Replace('_', '/');
                int mod = base64.Length % 4;
                if (mod > 0)
                {
                    base64 += new string('=', 4 - mod);
                }
                byte[] bytes = Convert.FromBase64String(base64);
                string key = "CodexVoiceShield2026";
                for (int i = 0; i < bytes.Length; i++)
                {
                    bytes[i] = (byte)(bytes[i] ^ key[i % key.Length]);
                }
                return System.Text.Encoding.UTF8.GetString(bytes);
            }
            catch
            {
                return null;
            }
        }

        private void AddOrUpdatePeer(string username, IPEndPoint ep)
        {
            lock (peersLock)
            {
                if (activePeers.TryGetValue(username, out var peer))
                {
                    peer.endpoint = ep;
                }
                else
                {
                    Console.WriteLine($"[CodexVoice] Establishing voice connection to peer: {username} ({ep})");
                    activePeers[username] = new RemotePeer(username, ep, sampleRate, frameSize);
                }
            }
        }

        private void OnReceivedFromServer(Grimoire.Networking.Message message)
        {
            if (message is XtMessage xtMsg)
            {
                if (xtMsg.Command == "chatm" || xtMsg.Command == "whisper")
                {
                    string sender = "";
                    string msgText = xtMsg.Arguments[4];
                    
                    if (xtMsg.Command == "chatm")
                    {
                        string rawSender = xtMsg.Arguments[5];
                        int tilde = rawSender.IndexOf('~');
                        sender = tilde >= 0 ? rawSender.Substring(tilde + 1) : rawSender;
                    }
                    else if (xtMsg.Command == "whisper")
                    {
                        sender = xtMsg.Arguments[5];
                    }
                    
                    HandleIncomingChat(sender, msgText);
                }
            }
        }

        public void SetVoiceVolume(float volume)
        {
            voiceVolume = Math.Max(0f, Math.Min(2.0f, volume));
            try
            {
                Botting.Config.Instance?.Set("CodexVoice_Volume", voiceVolume.ToString(System.Globalization.CultureInfo.InvariantCulture));
            }
            catch {}
        }

        public void SetVoiceBoost(float boost)
        {
            voiceBoost = Math.Max(0f, Math.Min(3.0f, boost));
            try
            {
                Botting.Config.Instance?.Set("CodexVoice_Boost", voiceBoost.ToString(System.Globalization.CultureInfo.InvariantCulture));
            }
            catch {}
        }

        public bool IsPeerSpeaking(string username)
        {
            lock (peersLock)
            {
                if (activePeers.TryGetValue(username, out var peer))
                {
                    return peer.IsSpeaking;
                }
            }
            return false;
        }

        public bool IsSelfSpeaking => micLevel > 0.03f && !isMuted;

        public List<string> GetActivePeerNames()
        {
            lock (peersLock)
            {
                return new List<string>(activePeers.Keys);
            }
        }

        public void ChangeMicrophone(int newIndex)
        {
            if (WaveInEvent.DeviceCount == 0) return;
            selectedMicIndex = newIndex;
            if (voiceEnabled && isRunning)
            {
                StopMicrophone();
                StartMicrophone();
            }
        }

        public static List<string> GetMicrophoneDevices()
        {
            List<string> devices = new List<string>();
            int deviceCount = WaveInEvent.DeviceCount;
            for (int i = 0; i < deviceCount; i++)
            {
                try
                {
                    var capabilities = WaveInEvent.GetCapabilities(i);
                    devices.Add(capabilities.ProductName);
                }
                catch
                {
                    devices.Add($"Microphone {i}");
                }
            }
            return devices;
        }
    }

    // Represents a Remote Player's Voice Stream
    public class RemotePeer : IDisposable
    {
        public string username;
        public IPEndPoint endpoint;
        public DateTime lastSeen = DateTime.UtcNow;
        public DateTime lastSpoke = DateTime.MinValue;
        public bool IsSpeaking => (DateTime.UtcNow - lastSpoke).TotalMilliseconds < 500;
        
        private OpusDecoder decoder;
        private WaveOutEvent waveOut;
        private BufferedWaveProvider waveProvider;
        private int sampleRate;
        private int frameSize;
        private List<byte> jitterBuffer = new List<byte>();
        private bool isBuffering = true;

        // Reusable arrays to prevent garbage collection pressure
        private short[] decodeBuffer;
        private short[] volAdjustedBuffer;
        private byte[] byteBuffer;

        public RemotePeer(string username, IPEndPoint endpoint, int sampleRate, int frameSize)
        {
            this.username = username;
            this.endpoint = endpoint;
            this.sampleRate = sampleRate;
            this.frameSize = frameSize;

            int channels = 2; // Stereo
            decoder = new OpusDecoder(sampleRate, channels);

            // Reusable buffers (Stereo: 960 * 2 = 1920 samples)
            int totalSamples = frameSize * channels;
            decodeBuffer = new short[totalSamples];
            volAdjustedBuffer = new short[totalSamples];
            byteBuffer = new byte[totalSamples * 2];

            waveProvider = new BufferedWaveProvider(new WaveFormat(sampleRate, 16, channels));
            waveProvider.DiscardOnBufferOverflow = true;
            // Shortened buffer duration to 1.5 seconds instead of 5 seconds to reduce drift latency
            waveProvider.BufferDuration = TimeSpan.FromSeconds(1.5);

            waveOut = new WaveOutEvent();
            waveOut.Init(waveProvider);
            waveOut.Play(); // Keep audio device running continuously
        }

        public void FeedAudio(byte[] data, int offset, int length)
        {
            try
            {
                int decodedSamples = decoder.Decode(data, offset, length, decodeBuffer, 0, frameSize, false);

                if (decodedSamples > 0)
                {
                    int totalSamples = decodedSamples * 2; // 2 channels
                    int byteCount = totalSamples * 2;

                    float peak = 0f;
                    for (int i = 0; i < totalSamples; i++)
                    {
                        float abs = Math.Abs(decodeBuffer[i] / 32767f);
                        if (abs > peak) peak = abs;
                    }
                    if (peak > 0.015f)
                    {
                        lastSpoke = DateTime.UtcNow;
                    }

                    float vol = GetSpatialVolume();
                    for (int i = 0; i < totalSamples; i++)
                    {
                        float val = (decodeBuffer[i] / 32767f) * vol;
                        val = Math.Min(1.0f, Math.Max(-1.0f, val));
                        volAdjustedBuffer[i] = (short)(val * 32767f);
                    }
                    Buffer.BlockCopy(volAdjustedBuffer, 0, byteBuffer, 0, byteCount);

                    // Rebuild jitter buffer in memory if output runs completely dry (packet starvation)
                    if (!isBuffering && waveProvider.BufferedBytes == 0)
                    {
                        isBuffering = true;
                    }

                    if (isBuffering)
                    {
                        // Ensure Capacity exists to avoid reallocation
                        if (jitterBuffer.Capacity < byteCount * 4)
                        {
                            jitterBuffer.Capacity = byteCount * 4;
                        }

                        for (int i = 0; i < byteCount; i++)
                        {
                            jitterBuffer.Add(byteBuffer[i]);
                        }

                        // Pre-buffer 4 packets before adding them to the NAudio buffer
                        if (jitterBuffer.Count >= byteCount * 4)
                        {
                            byte[] bufferedData = jitterBuffer.ToArray();
                            waveProvider.AddSamples(bufferedData, 0, bufferedData.Length);
                            jitterBuffer.Clear();
                            isBuffering = false;
                        }
                    }
                    else
                    {
                        waveProvider.AddSamples(byteBuffer, 0, byteCount);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[CodexVoice] Failed to decode audio packet from {username}: {ex.Message}");
            }
        }

        private float GetSpatialVolume()
        {
            if (VoiceChatManager.Instance == null) return 0f;
            
            float masterVol = VoiceChatManager.Instance.voiceVolume;
            if (VoiceChatManager.Instance.isDeafened) return 0f;

            if (VoiceChatManager.Instance.useExternalSignaling || VoiceChatManager.Instance.useWebSocket)
            {
                // In external signaling or WebSocket relay mode, the server already routes packets only to peers
                // in the same map/cell, so we can trust that any received audio is from our cell.
                return masterVol;
            }

            string currentCell = VoiceChatManager.Instance.CurrentCell;
            string peerCell = VoiceChatManager.Instance.GetPeerCell(username);
            
            if (string.IsNullOrEmpty(peerCell) || peerCell != currentCell)
            {
                return 0f;
            }

            return masterVol;
        }

        public void Dispose()
        {
            decoder = null;
            try
            {
                if (waveOut != null)
                {
                    waveOut.Stop();
                    waveOut.Dispose();
                    waveOut = null;
                }
                waveProvider = null;
            }
            catch {}
        }
    }
}

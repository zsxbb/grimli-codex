using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;

using Grimoire.Utils;

namespace Grimoire.GameProxy
{
    /// <summary>
    /// Intercepts traffice from the game client to the game server.
    /// </summary>
    public class CaptureProxy
    {
        private const int MaxDecompressedPacketBytes = 16 * 1024 * 1024;
        /// <summary>
        /// The default port for the capture proxy to run on.
        /// </summary>
        public const int DefaultPort = 5588;
        /// <summary>
        /// The destination server for the proxy to relay traffic to and from.
        /// </summary>
        public IPEndPoint Destination { get; set; }
        /// <summary>
        /// The list of packet interceptors.
        /// </summary>
        public List<Interceptor> Interceptors { get; } = new List<Interceptor>();
        /// <summary>
        /// Indicates whether the proxy is running or not.
        /// </summary>
        public bool Running { get; private set; }

        private bool _exit;
        private Thread _thread;
        private TcpListener _listener;
        private TcpClient _forwarder;
        private TcpClient _client;

        public CaptureProxy()
        {
            _listener = new TcpListener(IPAddress.Loopback, DefaultPort);
        }

        /// <summary>
        /// Starts the capture proxy.
        /// </summary>
        public void Start()
        {
            Running = true;
            _exit = false;
            _thread = new Thread(_Listen) { Name = "Capture Proxy" };
            _thread.Start();
        }

        /// <summary>
        /// Stops the capture proxy.
        /// </summary>
        public void Stop()
        {
            _exit = true;
            _listener?.Stop();
            if (_forwarder?.Connected ?? false)
                _forwarder.Close();
            if (_client?.Connected ?? false)
                _client.Close();
            if (_thread?.IsAlive ?? false)
            {
                _thread.Join(1000);
                _thread.Abort();
            }
            Running = false;
        }

        private void _Listen()
        {
            _listener.Start();
            while (!_exit)
            {
                try
                {
                    Console.WriteLine($"connect : {Destination.Address}:{Destination.Port}");
                    _client = _listener.AcceptTcpClient();
                    _forwarder = new TcpClient();
                    _forwarder.Connect(Destination);
                    Task.Factory.StartNew(() => _DataInterceptor(_client, _forwarder, true));
                    Task.Factory.StartNew(() => _DataInterceptor(_forwarder, _client, false));
                }
                catch (Exception e)
                {
                    Console.WriteLine("e : " + e.Message);
                }
            }
        }

        private async Task _DataInterceptor(TcpClient target, TcpClient destination, bool outbound)
        {
            byte[] msgbuf = new byte[4096];
            int read = 0;
            List<byte> cpacket = new List<byte>();
            NetworkStream targetStream = null;
            NetworkStream destStream = null;

            try
            {
                targetStream = target.GetStream();
                destStream = destination.GetStream();

                while (!_exit && target.Connected && destination.Connected)
                {
                    read = await targetStream.ReadAsync(msgbuf, 0, 4096);
                    if (read == 0)
                        break;

                    for (int i = 0; i < read; i++)
                    {
                        byte b = msgbuf[i];
                        if (b > 0)
                        {
                            cpacket.Add(b);
                        }
                        else
                        {
                            if (cpacket.Count == 0)
                            {
                                await destStream.WriteAsync(new byte[] { 0 }, 0, 1);
                                continue;
                            }

                            byte[] data = cpacket.ToArray();
                            cpacket.Clear();

                            string content = Encoding.UTF8.GetString(data);
                            bool compressed = !outbound && _TryUnpack(content, out content);
                            MessageInfo message = new MessageInfo(content);

                            if (Interceptors.Count > 0)
                            {
                                Interceptors.OrderBy(x => x.Priority).ForEach(x => x.Intercept(message, outbound));
                            }

                            if (_exit || !target.Connected || !destination.Connected)
                                break;

                            if (message.Send)
                            {
                                byte[] contentBytes = message.Content == content ? data
                                    : compressed ? _Pack(message.Content) : Encoding.UTF8.GetBytes(message.Content);
                                byte[] msg = new byte[contentBytes.Length + 1];
                                Buffer.BlockCopy(contentBytes, 0, msg, 0, contentBytes.Length);
                                await destStream.WriteAsync(msg, 0, msg.Length);
                            }
                        }
                    }
                }
            }
            catch (Exception e) when (e is IOException || e is SocketException || e is ObjectDisposedException)
            {
                /* Connection closed cleanly */
            }
            catch (Exception ex)
            {
                Console.WriteLine("Proxy error: " + ex.Message);
            }
            finally
            {
                try { targetStream?.Dispose(); } catch { }
                try { destStream?.Dispose(); } catch { }
            }
        }

        private static bool _TryUnpack(string message, out string content)
        {
            content = message;
            if (string.IsNullOrEmpty(message) || !message.StartsWith("Z"))
                return false;

            try
            {
                const string alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
                int end = message.Length;
                while (end > 1 && message[end - 1] == '=')
                    end--;

                byte[] compressed = new byte[(end - 1) * 3 / 4];
                if (compressed.Length < 8)
                    return false;

                int bits = 0, bitCount = 0, count = 0;
                for (int i = 1; i < end; i++)
                {
                    if (message[i] > 255)
                        throw new InvalidDataException("Invalid compressed packet character.");
                    bits = bits << 6 | Math.Max(0, alphabet.IndexOf(message[i]));
                    bitCount += 6;
                    if (bitCount >= 8)
                    {
                        bitCount -= 8;
                        compressed[count++] = (byte)(bits >> bitCount);
                    }
                }

                if (count < 6)
                    return false;

                using (MemoryStream input = new MemoryStream(compressed, 2, count - 6))
                using (DeflateStream deflate = new DeflateStream(input, CompressionMode.Decompress))
                using (MemoryStream output = new MemoryStream())
                {
                    byte[] buffer = new byte[8192];
                    int read;
                    while ((read = deflate.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        if (read > MaxDecompressedPacketBytes - output.Length)
                            throw new InvalidDataException("Packet too large.");
                        output.Write(buffer, 0, read);
                    }
                    content = Encoding.UTF8.GetString(output.ToArray());
                    return true;
                }
            }
            catch (Exception)
            {
                return false;
            }
        }

        private static byte[] _Pack(string content)
        {
            byte[] raw = Encoding.UTF8.GetBytes(content);
            using (MemoryStream output = new MemoryStream())
            {
                output.WriteByte(0x78);
                output.WriteByte(0x9C);
                using (DeflateStream deflate = new DeflateStream(output, CompressionMode.Compress, true))
                {
                    deflate.Write(raw, 0, raw.Length);
                }

                uint a = 1, b = 0;
                for (int i = 0; i < raw.Length; i++)
                {
                    a = (a + raw[i]) % 65521;
                    b = (b + a) % 65521;
                }
                uint adler = (b << 16) | a;
                output.WriteByte((byte)(adler >> 24));
                output.WriteByte((byte)(adler >> 16));
                output.WriteByte((byte)(adler >> 8));
                output.WriteByte((byte)adler);

                return Encoding.ASCII.GetBytes("Z" + Convert.ToBase64String(output.ToArray()));
            }
        }
    }
}

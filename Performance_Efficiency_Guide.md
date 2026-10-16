# GrimCodex Performance & Efficiency Guide

This guide details code-level and environment optimizations to eliminate game stutters (micro-lags), manage CPU/GPU resource allocation, and prevent the characteristic memory leaks in GrimCodex.

---

## 1. Threading & Multi-Core CPU Optimization

### 🔴 The Constraint: Single-Threaded Flash
Adobe Flash Player ActiveX operates almost entirely on a **single CPU core** (the main thread). Heavy tasks run synchronously inside the Flash runtime, meaning that even on high-core processors, Flash will max out one core and cause framerate drops.

### 🟢 C# Multi-Threading Strategies
To prevent C# from competing with Flash for CPU time:
1. **Move Heavy I/O to Background Threads**: Ensure packet parsing, configuration writing, and server pings are handled on the `.NET ThreadPool` using `Task.Run` or `backgroundWorker`.
2. **Minimize UI Dispatching**: UI updates in C# (`BeginInvoke`/`Invoke`) should be batched to prevent message queue congestion, which blocks the Flash control.
3. **Affinity Mapping (Advanced)**: You can bind the GrimCodex process to specific cores (preventing it from using Core 0, which Windows reserves for critical OS processes) by setting the process affinity mask:
   ```csharp
   using System.Diagnostics;
   // Set affinity to all cores EXCEPT CPU 0 (e.g. for an 8-thread CPU, mask is 0xFE)
   Process.GetCurrentProcess().ProcessorAffinity = (IntPtr)(0xFFFE & (int)Process.GetCurrentProcess().ProcessorAffinity);
   ```

---

## 2. Hardware Acceleration & GPU Utilization

### 🔴 The Constraint: ActiveX Hosting vs. Browser Engine
AQW is a 2D vector-graphics game. Historically, Flash renders vectors using the CPU. 
When comparing the GrimCodex C# client (which hosts `AxShockwaveFlash` ActiveX) to an older browser (like Comodo Dragon):
1. **Comodo Dragon (Chromium/Pepper Flash)** runs Flash in a dedicated process utilizing Chromium's sandboxed GPU compositor. This bypasses the Windows Forms main thread message loop entirely and utilizes high-performance DirectX/OpenGL rasterization, achieving higher GPU utilization (~15%).
2. **GrimCodex (ActiveX Control)** hosts the Flash Player within the same process. It is bound by the C# `WM_PAINT` message loop and GDI+ rendering context. If a single CPU core is bottlenecked (e.g. by heavy bot/game logic running at 100%), the CPU cannot feed the GPU fast enough, limiting GPU utilization (to ~8%).

### 🟢 Optimization Steps

#### 1. Configurable Client Settings (`ClientConfig.cfg`)
You can configure both the Window Mode and Rendering Quality dynamically via `ClientConfig.cfg`:
```ini
wmode=direct
quality=High
```
* **`wmode` Options**:
  - `direct`: (Default) Direct3D pipeline rendering. Best for systems with modern GPU compatibility.
  - `gpu`: Utilizes the GPU primarily for compositing and vector blending. Can yield higher GPU utilization on older systems/hybrid laptops.
  - `opaque` / `window`: Fallback software rendering modes.
* **`quality` Options**:
  - `High` / `Best`: Standard settings with vector anti-aliasing (CPU intensive).
  - `Medium` / `Low`: Disables sub-pixel smoothing. Dramatically reduces CPU overhead, alleviating the thread bottleneck and allowing the GPU to run at maximum possible throughput.

#### 2. System-Level GPU Validation Override (`mms.cfg`)
Flash Player has an internal GPU blacklist. If your GPU driver version or model fails Flash's compatibility validation, it silently falls back to 100% Software rendering (lowering GPU usage).
To force hardware acceleration:
1. Open Notepad as **Administrator**.
2. Create or edit the following file depending on your system:
   * **64-bit Windows**: `C:\Windows\SysWOW64\Macromed\Flash\mms.cfg`
   * **32-bit Windows**: `C:\Windows\System32\Macromed\Flash\mms.cfg`
3. Add/edit the following values:
   ```ini
   DisableHardwareAcceleration=0
   OverrideGPUValidation=1
   ```
4. Save the file with **UTF-8** or **ANSI** encoding.

#### 3. Assigning the Dedicated GPU (Windows Settings)
For laptops with hybrid graphics (Intel UHD/Iris Xe + NVIDIA/AMD Dedicated GPU):
1. Open Windows **Graphics Settings** (Settings > System > Display > Graphics).
2. Click **Browse** and select your built GrimCodex executable (`Grimoire.exe`).
3. Click **Options**, select **High Performance** (which assigns the dedicated GPU), and click **Save**.

----

## 3. Flash Memory Leak Mitigation (RAM Growth)

### 🔴 The Leak: ActiveX Allocation Growth
Flash ActiveX does not release memory reliably when cleaning up DisplayObjects. Over time, the trainer's memory footprints can rise from 200MB to over 1GB, causing garbage collection spikes that lead to 2-3 second freezes.

### 🟢 The Solution: Process Working Set Trimming
We can force the Windows kernel to reclaim leaked physical RAM blocks by triggering periodic compaction.

* **Code Implementation (`MemoryOptimizer.cs`)**:
  ```csharp
  using System;
  using System.Diagnostics;
  using System.Runtime.InteropServices;

  public static class MemoryOptimizer
  {
      [DllImport("kernel32.dll", EntryPoint = "SetProcessWorkingSetSize")]
      private static extern int SetProcessWorkingSetSize(IntPtr process, int minimumWorkingSetSize, int maximumWorkingSetSize);

      public static void MinimizeMemory()
      {
          try
          {
              GC.Collect();
              GC.WaitForPendingFinalizers();
              if (Environment.OSVersion.Platform == PlatformID.Win32NT)
              {
                 SetProcessWorkingSetSize(Process.GetCurrentProcess().Handle, -1, -1);
              }
          }
          catch { }
      }
  }
  ```
* **Triggering**: Run `MemoryOptimizer.MinimizeMemory()` on a C# `System.Windows.Forms.Timer` set to fire every **3 to 5 minutes**, or on transition events (e.g., when the player successfully joins a new map or changes servers).

---

## 4. Socket & Spill Buffer Allocation Tuning

### 🔴 The Bottleneck: Frequent GC Sweeps
Inside `GrimoireClient.cs`, the network socket parses packets and creates a new byte list for the spill buffer:
```csharp
string @string = Encoding.UTF8.GetString(this._spillBuffer.ToArray());
this._spillBuffer = new List<byte>();
```
In fast-paced maps where hundreds of packets arrive per second, instantiating new arrays causes constant Garbage Collection, causing noticeable stutter.

### 🟢 The Solution: Buffer Reuse
Avoid recreating the `List<byte>` container. Re-use the existing instance to eliminate allocations:
```csharp
string @string = Encoding.UTF8.GetString(this._spillBuffer.ToArray());
this._spillBuffer.Clear(); // Clears internal pointers without releasing the memory backing array
```

---

## 5. UI Loop Throttling (Externalizer AS3)

### 🔴 The Bottleneck: Per-Frame Tree Searching
Scanning UI containers inside the Flash client runs on every frame (`onRootEnterFrame`). Reflectively searching nodes at 30-60 FPS eats up to 25% of single-core performance.

### 🟢 The Solution: Frame Throttling
Wrap heavy UI scanning logic inside a frame counter check so that it only runs once every 6 frames:
```actionscript
private var scanCounter:int = 0;

private function onRootEnterFrame(event:Event):void {
    scanCounter++;
    if (scanCounter % 6 == 0) {
        // Run heavy list sorting, favored items verification, and container scans
    }
}
```
This drops scanning frequency to ~10 times per second, which feels responsive to the user but cuts rendering-thread load by **83%**.

---

## 6. Grim vs. Browser CPU Bottleneck Mitigation

### 🔴 The Bottleneck: Why Grim is Heavier than Browser
1. **Network Interceptor Proxy**: GrimCodex routes all game traffic through a local C# TCP proxy. Every network packet is parsed, inspected by handlers, and modified (if necessary) in C# memory. In busy maps, this causes substantial string manipulation overhead compared to a browser which receives data directly via Flash Player.
2. **Infinite Hot Loops (Resolved)**: 
   * **Background Packet Spammer**: If a background packet spammer command was running and the player entered a quest completion state (`_onCompletingQuest`), the loop previously spun continuously without a delay, maxing out a CPU core. This has been fixed by introducing a 100ms yield state during quest completion.
   * **Stale Capture Proxy Tasks**: When a client/forwarder socket was disconnected, `ReadAsync` would return 0, but instead of breaking, the task previously slept for 10ms and spun indefinitely in the background, consuming CPU resources. This has been resolved by breaking the loop on zero-byte reads.
3. **WinForms GUI Threading**: Unlike chromium browsers that offload rendering and UI to separate processes, GrimCodex shares the UI thread with WinForms layout engines, debug logs, and list updates.

### 🟢 Optimization Recommendations
To make GrimCodex much lighter on your CPU:
1. **Reduce FPS**: Flash vector scaling calculations are done on the CPU. Lowering the client FPS in `ClientConfig.cfg` (e.g. set `fps=24` or `fps=30` instead of `60`) reduces the CPU's rendering overhead.
2. **Lower Kualitas (Quality)**: Change `quality=Medium` or `quality=Low` in `ClientConfig.cfg`. This disables antialiasing, reducing CPU load significantly.
3. **Turn on Lag Killer & Disable Animations**: Inside Grimoire Options, enable **Lag Killer** and **Disable Animations**. This prevents the vector graphics engine from drawing maps, player skins, and combat spell animations on screen, which is the single most CPU-intensive part of AQW.
4. **Close Debug Log Windows**: Do not leave the debug log window open during heavy bot runs. WinForms textbox rendering is heavy on CPU thread layout recalculation.

---

## 7. Voice Chat Signaling & Packet Routing Optimizations (Resolved)

### 🔴 The Issue: Silent Muting & Client-Side Desynchronization
1. **Flash COM Call Overhead**: The voice system previously invoked `World.RefreshDictionary()` (which makes an ActiveX COM call to serialize the game's player dictionary) every 1 second. This created unnecessary overhead on the UI thread.
2. **"Hide Players" Incompatibility**: When users enabled "Hide Players" (Lag Killer) to optimize performance, Flash destroyed the player objects. Consequently, the other players were missing from the client-side list (`World.Players`), causing the client to silently mute their audio (`volume = 0f`) and immediately remove them from the active peer list.
3. **Signaling Room Casing Mismatch**: The signaling server routed UDP packets based on case-sensitive map and cell checks, preventing audio relays if there were capitalization discrepancies in map or cell names reported by different clients.

### 🟢 The Solution: UDP Keep-Alive Timeout & Case Normalization
1. **Bypassing Flash COM Calls**: When `useExternalSignaling` is enabled (default), the client now relies entirely on the external server to handle room and cell routing. The client completely skips calling `UpdatePeerCells()` and `World.RefreshDictionary()`, saving CPU cycles.
2. **UDP-Based Timeout**: Instead of relying on `World.Players` to check if a player is still in the room/cell, the client now tracks incoming keep-alive and audio UDP packets. Peers are maintained in the active list and kept unmuted as long as they send any packet (keep-alive or voice) within a rolling 8-second window.
3. **Case-Insensitive Server-Side Routing**: The Node.js signaling server now normalizes map and cell names to lowercase upon receipt, ensuring reliable UDP packet forwarding regardless of how clients format map/cell capitalization.



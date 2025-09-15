
# Performance-Monitor

# 1. Aztec Node Uptime

If node is running


⏱️  Aztec Node Uptime:
Up 3 hours 

If not running


⏱️  Aztec Node Uptime:
Aztec node not running

# Right now script only checks:

Whether the directory exists (/aztec or /Ethereum)

Whether the containers Up inside that directory.

That means it’s confirming the containers are up — but it does not confirm if the node is actually working properly like syncing, producing blocks, responding to RPC calls etc...

---

# 2. CPU & RAM Usage

Always shows real-time usage:


🖥️  CPU & RAM Usage:
CPU Load: 12.5%

Memory Usage: 63.45% (1024MB/1613MB)


---

# 3. Docker (Aztec Node)

If aztec directory exists + node running


📦 Docker (Aztec Node):

NAME   

IMAGE 

STATUS

  
If aztec directory missing


📦:
Aztec directory not found


---

# 4. RPC Check (Ethereum directory)

If RPC running


🌐 RPC Check:
✅ RPC is running

If RPC directory missing


🌐 RPC Check:
Ethereum directory not found

If installed but stopped


🌐 RPC Check:
❌ RPC is not running


---

# 5. Storage Usage

Normal case


💾 Storage Usage:
✅ 45% used (28G available)

Low disk warning (<10% free)


💾 Storage Usage:
⚠️  92% used (2G available) [LOW DISK SPACE]


---

# 6. UFW Port Check

If ports are open


🔒 UFW Port Check:

✅ Port 40400/udp is open

✅ Port 40400/tcp is open

✅ Port 8080 is open

✅ Port 8545 is open

✅ Port 3500 is open

``Ignore 8545,3500 if not hosting self RPC``

If port is closed


❌ Port 8080 is closed


---

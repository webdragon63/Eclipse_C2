menu_of_teamserver_options() {
echo -e "\n\e[97m[+] \e[96mChoose your choice:\n"
sleep 1
echo -e "\e[97m[1] \e[96mScripted Web Delivery"
echo -e "\e[97m[2] \e[96mNormal Teamserver With Your Custom Reverse Shell Script"
echo -e "\e[97m[3] \e[96mMake Beacon for Windows"
echo -e "\e[97m[4] \e[96mMake Beacon for Linux"
echo -e "\e[97m[5] \033[0;31mexit\e[96m"
echo -n "Please select an option: "
}

choice_of_teamserver(){
    case $1 in
        1) bash src/teamserver/web_delivery/web_delivery.sh;;
        2) ./src/teamserver/exec/teamserver;;
        3) bash src/teamserver/beacon.sh;;
        4) bash src/teamserver/beacon_linux.sh;;
        5) echo "Exiting..."; exit 0;;
        *) echo "Invalid option";;
    esac
}

while true; do
    menu_of_teamserver_options
    read choice
    choice_of_teamserver $choice
    echo -e "\nPress any key to return to the menu..."
    read -n 1
done

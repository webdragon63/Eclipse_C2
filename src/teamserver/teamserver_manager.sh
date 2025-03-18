menu_of_teamserver_options() {
echo -e "\e[97mDo you want to use \e[93mScripted_Web_Delivery \e[97mservice or \e[93mNormal Teamserver With Your Custom Reverse Shell Script \e[97mservice?\e[96m"
echo "[1] Scripted Web Delivery"
echo "[2] Normal Teamserver With Your Custom Reverse Shell Script"
echo "[3] exit"
echo -n "Please select an option: "
}

choice_of_teamserver(){
    case $1 in
        1) bash src/teamserver/web_delivery/web_delivery.sh;;
        2) ./src/teamserver/teamserver;;
        3) echo "Exiting..."; exit 0;;
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

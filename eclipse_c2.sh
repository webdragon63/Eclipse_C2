#!/bin/bash

# Find the Previous PIDs of web_delivery processes
pids=$(pgrep -f "web_delivery")

# Check if any PIDs were found
if [ -n "$pids" ]; then
    echo "Killing previous web_delivery processes: $pids"
    kill -9 $pids
else
    echo "No web_delivery processes found."
fi

# Define futuristic border elements
clear
TOP_LEFT="╭─╼"
TOP_RIGHT="╾─╮"
BOTTOM_LEFT="╰─╼"
BOTTOM_RIGHT="╾─╯"
HORIZONTAL="───"
VERTICAL="│"

# Define ASCII text
lines=(
    "┏━╸┏━╸╻  ╻┏━┓┏━┓┏━╸   ┏━╸┏━┓"
    "┣╸ ┃  ┃  ┃┣━┛┗━┓┣╸    ┃  ┏━┛"
    "┗━╸┗━╸┗━╸╹╹  ┗━┛┗━╸╺━╸┗━╸┗━╸"
)

# Get terminal size
rows=$(tput lines)
cols=$(tput cols)

# Calculate text dimensions
max_length=0
for line in "${lines[@]}"; do
    (( ${#line} > max_length )) && max_length=${#line}
done

# Border padding
padding=3
border_width=$(( max_length + 2 * padding ))
border_height=$(( ${#lines[@]} + 2 * padding ))

# Calculate center position
start_row=$(( (rows - border_height) / 2 ))
start_col=$(( (cols - border_width) / 2 ))

# ANSI colors (neon cyberpunk effect)
CYAN="\e[96m"
BLUE="\e[94m"
RESET="\e[0m"

# Hide cursor
tput civis

# Draw border with animation
for ((i=0; i<border_width; i++)); do
    tput cup $start_row $((start_col + i))
    echo -ne "${CYAN}${HORIZONTAL}${RESET}"
    tput cup $((start_row + border_height - 1)) $((start_col + i))
    echo -ne "${CYAN}${HORIZONTAL}${RESET}"
    sleep 0.01
done

for ((i=0; i<border_height; i++)); do
    tput cup $((start_row + i)) $start_col
    echo -ne "${CYAN}${VERTICAL}${RESET}"
    tput cup $((start_row + i)) $((start_col + border_width - 1))
    echo -ne "${CYAN}${VERTICAL}${RESET}"
    sleep 0.01
done

# Draw corners
tput cup $start_row $start_col
echo -ne "${BLUE}${TOP_LEFT}${RESET}"
tput cup $start_row $((start_col + border_width - 1))
echo -ne "${BLUE}${TOP_RIGHT}${RESET}"
tput cup $((start_row + border_height - 1)) $start_col
echo -ne "${BLUE}${BOTTOM_LEFT}${RESET}"
tput cup $((start_row + border_height - 1)) $((start_col + border_width - 1))
echo -ne "${BLUE}${BOTTOM_RIGHT}${RESET}"

# Animate text appearing inside the border
for ((i=0; i<=max_length; i++)); do
    for ((j=0; j<${#lines[@]}; j++)); do
        char="${lines[j]:i:1}"
        if [[ -n "$char" ]]; then
            tput cup $((start_row + padding + j)) $((start_col + padding + i))
            color=$([[ $((i % 2)) -eq 0 ]] && echo "$CYAN" || echo "$BLUE") # Alternate glow effect
            echo -ne "${color}${char}${RESET}"
        fi
    done
    sleep 0.02
done

# Show cursor again
tput cnorm
echo ""

sleep  0.9

# Clear terminal to avoid glitches
clear

# Define futuristic border characters
TOP_LEFT="╭─╼"
TOP_RIGHT="╾─╮"
BOTTOM_LEFT="╰─╼"
BOTTOM_RIGHT="╾─╯"
HORIZONTAL="──"
VERTICAL="│"

# ASCII Art Text (Keep spacing as needed)
HEADER_TEXT="    ┏━╸┏━╸╻  ╻┏━┓┏━┓┏━╸   ┏━╸┏━┓
    ┣╸ ┃  ┃  ┃┣━┛┗━┓┣╸    ┃  ┏━┛
    ┗━╸┗━╸┗━╸╹╹  ┗━┛┗━╸╺━╸┗━╸┗━╸
|THE MODERN C2 MADE BY WEB_DRAGON63|"

# Get terminal width
cols=$(tput cols)

# Determine the longest line in ASCII text
max_length=0
while IFS= read -r line; do
    [[ ${#line} -gt $max_length ]] && max_length=${#line}
done <<< "$HEADER_TEXT"

# Calculate header width (ASCII width + padding)
padding=2
header_width=$(( max_length + 4 * padding ))

# Center horizontally
start_col=$(( (cols - header_width) / 2 ))

# ANSI colors (cyberpunk glow effect)
CYAN="\e[96m"
BLUE="\e[94m"
RESET="\e[0m"

# Hide cursor
tput civis

# Draw top border
tput cup 1 $start_col
echo -ne "${CYAN}${TOP_LEFT}"
for ((i=0; i<header_width-27; i++)); do echo -ne "${CYAN}${HORIZONTAL}"; done
echo -ne "${CYAN}${TOP_RIGHT}${RESET}"

# Print ASCII text with borders
row=2
while IFS= read -r line; do
    tput cup $row $start_col
    echo -ne "${CYAN}${VERTICAL}${RESET} "
    echo -ne "${BLUE}${line}$(printf '%*s' $((max_length - ${#line})))${RESET} "
    echo -ne "${CYAN}${VERTICAL}${RESET}"
    ((row++))
done <<< "$HEADER_TEXT"

# Draw bottom border
tput cup $row $start_col
echo -ne "${CYAN}${BOTTOM_LEFT}"
for ((i=0; i<header_width-27; i++)); do echo -ne "${CYAN}${HORIZONTAL}"; done
echo -ne "${CYAN}${BOTTOM_RIGHT}${RESET}"

# Giving executables permission 
chmod +x  src/teamserver/exec/teamserver
chmod +x  src/teamserver/exec/teamserver_2
chmod +x  src/teamserver/web_delivery/exec/web_delivery

# Show cursor again
tput cnorm
echo -e "\n"

VERMILION='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN="\e[96m"
WHITE='\033[0;37m'
sleep 0.5
menu() {
echo -e "\e[96mDo you want to use teamserver or a netcat multi-handler?"
echo -e "${WHITE}[1] ${CYAN}Teamserver ${BLUE}(Capable to handle 15 clients)"
echo -e "${WHITE}[2] ${CYAN}Netcat-Multihandler Normal ${BLUE}(Can handle only one client)"
echo -e "${WHITE}[3] ${CYAN}Netcat-Multihandler With SSL ${BLUE}(Can handle only one client)"
echo -e "${WHITE}[4] ${VERMILION}exit${CYAN}"
echo -n "Please select an option: "
}
choice(){
    case $1 in
        1) bash src/teamserver/teamserver_manager.sh;;
        2) bash src/multihandler/multihandler.sh;;
        3) bash src/multihandler/cus_nc_ssl.sh;;
        4) echo "Exiting..."; exit 0;;
        *) echo "Invalid option";;
    esac
}

while true; do
    menu
    read choice
    choice $choice
    echo -e "\nPress any key to return to the menu..."
    read -n 1
done

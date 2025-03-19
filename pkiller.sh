#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Find the PIDs of web_delivery processes
pids=$(pgrep -f "web_delivery")

# Check if any PIDs were found
if [ -n "$pids" ]; then
    echo "Killing previous web_delivery processes: $pids"
    kill -9 $pids
else
    echo "No web_delivery processes found."
fi

#!/usr/bin/env bash

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0 # File exists
    else
        return 1 # File does not exist
    fi
}

sleep 0.3
#Restart waybar
systemctl --user restart waybar.service

exit 0

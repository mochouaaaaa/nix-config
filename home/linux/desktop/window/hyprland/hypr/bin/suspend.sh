#!/usr/bin/env bash

hyprctl workspaces > /dev/null

if [ $? -ne 0 ]; then
    systemctl suspend
fi

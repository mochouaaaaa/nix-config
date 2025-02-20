#!/usr/bin/env bash

iDIR="$HOME/.config/swaync/icons"
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"

time=$(date "+%d-%b_%H-%M-%S")
dir="$(xdg-user-dir)/Pictures/Screenshots"
file="Screenshot_${time}_${RANDOM}.png"
full_path="${dir}/${file}"

# Ensure screenshot directory exists
mkdir -p "$dir"

# Function: Notify and handle sound
notify_view() {
    local msg=$1
    local success=$2
    if [[ "$success" -eq 1 ]]; then
        ${notify_cmd_shot} "$msg"
        "Sounds.sh" --screenshot
    else
        ${notify_cmd_shot} "Screenshot NOT saved: $msg"
        "Sounds.sh" --error
    fi
}

# Function: Take screenshot with grim
take_shot() {
    local geometry=$1
    local output_path=$2
    grim -g "$geometry" - | tee "$output_path" | wl-copy
    if [[ -e "$output_path" ]]; then
        notify_view "Screenshot saved: $(basename "$output_path")" 1
    else
        notify_view "Failed to save screenshot" 0
    fi
}

# Function: Countdown timer
countdown() {
    local seconds=$1
    for sec in $(seq "$seconds" -1 1); do
        notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR/timer.png" "Taking shot in: $sec"
        sleep 1
    done
}

# Function: Capture active window
capture_active_window() {
    local geometry
    geometry=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    take_shot "$geometry" "$full_path"
}

# Function: Capture selected area
capture_area() {
    local geometry
    geometry=$(slurp)
    if [[ -n "$geometry" ]]; then
        take_shot "$geometry" "$full_path"
    else
        notify_view "No area selected" 0
    fi
}

# Function: Capture with swappy
capture_with_swappy() {
    local tmpfile
    tmpfile=$(mktemp)
    grim -g "$(slurp)" - >"$tmpfile" && wl-copy <"$tmpfile"
    if [[ -s "$tmpfile" ]]; then
        swappy -f "$tmpfile"
        mv "$tmpfile" "$full_path"
        notify_view "Screenshot edited and saved" 1
    else
        notify_view "Failed to capture screenshot" 0
    fi
    rm -f "$tmpfile"
}

# Screenshot options
case "$1" in
--now)
    take_shot "" "$full_path"
    ;;
--in5)
    countdown 5
    take_shot "" "$full_path"
    ;;
--in10)
    countdown 10
    take_shot "" "$full_path"
    ;;
--win)
    capture_active_window
    ;;
--area)
    capture_area
    ;;
--active)
    capture_active_window
    ;;
--swappy)
    capture_with_swappy
    ;;
*)
    echo -e "Available Options: --now --in5 --in10 --win --area --active --swappy"
    ;;
esac

exit 0

#!/usr/bin/env bash

# get window float state
is_float=$(hyprctl activewindow | grep "floating:" | awk '{print $2}')
echo $is_float
if [[ "$is_float" == "0" ]]; then
    hyprctl dispatch togglefloating
fi

# 初始化移动方向和大小
move_dir=""
new_width=""
new_height=""

# 判断传入的方向
case "$1" in
"left")
    new_width="50"  # 宽度为屏幕的一半
    new_height="97" # 高度为全屏
    move_dir="l"
    ;;
"right")
    new_width="50"
    new_height="97"
    move_dir="r"
    ;;
"up")
    new_width="100"
    new_height="50" # 高度为屏幕的一半
    move_dir="u"
    ;;
"down")
    new_width="100"
    new_height="50"
    move_dir="d"
    ;;
"top-left")
    new_width="50"
    new_height="50"
    move_dir="l,u"
    ;;
"top-right")
    new_width="50"
    new_height="50"
    move_dir="r,u"
    ;;
"bottom-left")
    new_width="50"
    new_height="50"
    move_dir="l,d"
    ;;
"bottom-right")
    new_width="50"
    new_height="50"
    move_dir="r,d"
    ;;
*)
    echo "Usage: $0 {left|right|up|down|top-left|top-right|bottom-left|bottom-right}"
    exit 1
    ;;
esac

# 使用 IFS 分割 move_dir 并移动窗口
IFS=',' # 分隔多个方向
for dir in $move_dir; do
    hyprctl dispatch movewindow "$dir"
done
sleep 0.3
# 设置窗口大小（百分比）
echo $new_width $new_height
hyprctl dispatch resizeactive exact "$new_width%" "$new_height%"

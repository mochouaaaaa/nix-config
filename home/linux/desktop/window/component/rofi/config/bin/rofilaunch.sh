#!/usr/bin/env sh

#// set variables

scrDir="$(dirname "$(realpath "$0")")"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
rofiStyle=1

roconf="${confDir}/rofi/styles/style_${rofiStyle}.rasi"
echo $roconf

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10

echo $rofiScale

if [ ! -f "${roconf}" ]; then
    roconf="$(find "${confDir}/rofi/styles" -type f -name "style_*.rasi" | sort -t '_' -k 2 -n | head -1)"
fi

#// rofi action

case "${1}" in
d | --drun) r_mode="drun" ;;
w | --window) r_mode="window" ;;
f | --filebrowser) r_mode="filebrowser" ;;
h | --help)
    echo -e "$(basename "${0}") [action]"
    echo "d :  drun mode"
    echo "w :  window mode"
    echo "f :  filebrowser mode,"
    exit 0
    ;;
*) r_mode="drun" ;;
esac

#// set overrides

hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"

wind_border=$((hypr_border * 3))
[ "${hypr_border}" -eq 0 ] && elem_border="10" || elem_border=$((hypr_border * 2))
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
# i_override="$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")"
# i_override="configuration {icon-theme: \"${i_override}\";}"

#// launch rofi

echo ${r_mode}
echo ${r_scale}
echo ${r_override}
# echo ${i_override}
echo ${roconf}

echo 'rofi -show "${r_mode}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}"'
# rofi -show "${r_mode}" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${i_override}" -config "${roconf}"
rofi -show "${r_mode}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}"

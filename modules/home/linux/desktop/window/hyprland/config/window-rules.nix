{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "opacity $windowOpacity override, fullscreen:0"

          "opaque, class:foot|equibop|imv|swappy" # They use native transparency or we want them opaque
          "center 1, floating:1, xwayland:0" # Center all floating windows (not xwayland cause popups)

          # opacity
          "opacity 0.78, class:^(firefox|chromium-browser)$"
          "opacity 0.78, class:^(io.github.kukuruzka165.materialgram)$"

          # Float
          "float, class:guifetch" # FlafyDev/guifetch
          "float, class:yad"
          "float, class:zenity"
          "float, class:wev"
          "float, class:org\.gnome\.FileRoller"
          "float, class:file-roller" # WHY IS THERE TWOOOOOOOOOOOOOOOO
          "float, class:blueman-manager"
          "float, class:com\.github\.GradienceTeam\.Gradience"
          "float, class:feh"
          "float, class:imv"
          "float, class:system-config-printer"

          # Float, resize and center
          "float, class:foot, title:nmtui"
          "size 60% 70%, class:foot, title:nmtui"
          "center 1, class:foot, title:nmtui"
          "float, class:org\.gnome\.Settings"
          "size 70% 80%, class:org\.gnome\.Settings"
          "center 1, class:org\.gnome\.Settings"
          "float, class:org\.pulseaudio\.pavucontrol|yad-icon-browser"
          "size 60% 70%, class:org\.pulseaudio\.pavucontrol|yad-icon-browser"
          "center 1, class:org\.pulseaudio\.pavucontrol|yad-icon-browser"
          "float, class:nwg-look"
          "size 50% 60%, class:nwg-look"
          "center 1, class:nwg-look"

          # windowrule Position
          "center,class:^([Ww]hatsapp-for-linux)$"
          "center,class:^([Ff]erdium)$"

          # flameshot
          "move 0 0,title:^(flameshot)"
          "pin, class:^(flameshot)$"
          "suppressevent fullscreen,title:^(flameshot)"
          "float, class:(flameshot), title:(flameshot-pin)"

          # filemanager
          "center, class:([Tt]hunar), title:^([Tt]hunar)$, size: 1200,1300"
          "center, class:([Tt]hunar), title:(Confirm to replace files)"
          "float, class:^(org.gnome.Nautilus|thunar|pcmanfm|dolphin)$"
          "float, class:([Tt]hunar), title:(File Operation Progress)"
          "float, class:([Tt]hunar), title:(Confirm to replace files)"

          "float, class:chromium-browser, title:(雀魂麻将 - Chromium)"
          "float, class:(pot|.pot-wrapped), title:(Translate|Translator|OCR|PopClip|Screenshot Translate)" # Translation window floating
          "float, class:(org.telegram.desktop), title:(Media viewer)"
          "float, title:overskride"
          "float, title:QQ"
          "float, title:图片查看器"

          "float, class:(VirtualBox)"
          "float, class:firefox,title:(我的足迹)"
          "float, class:firefox,title:画中画"

          "float, class:(xfce4-appfinder)"
          "float, class:kitty, title:yazi"
          "float, class:^(gnome-)"
          "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "float, class:([Zz]oom|onedriver|onedriver-launcher)$"

          "float, class:(xdg-desktop-portal-gtk)"
          "float, class:(org.gnome.Calculator), title:(Calculator)"
          "float, class:(codium|codium-url-handler|VSCodium), title:(Add Folder to Workspace)"
          "float, class:^([Rr]ofi)$"
          "float, class:^(eog|org.gnome.Loupe)$" # image viewer
          "float, class:^(mpv|com.github.rafostar.Clapper)$"
          "float, class:^(nm-applet|nm-connection-editor|blueman-manager)$"
          "float, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" # system monitor
          "float, class:^([Yy]ad)$"
          "float, class:^(wihotspot(-gui)?)$" # wifi hotspot
          "float, class:^(evince)$" # document viewer
          "float, class:^(file-roller|org.gnome.FileRoller)$" # archive manager
          "float, class:^([Bb]aobab|org.gnome.[Bb]aobab)$" # Disk usage analyzer
          "float, title:(Kvantum Manager)"
          "float, class:^([Qq]alculate-gtk)$"
          "float, class:^([Ff]erdium)$"

          "size 70% 70%, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$"
          "size 70% 70%, class:^(xdg-desktop-portal-gtk)$"
          "size 60% 70%, title:(Kvantum Manager)"
          "size 60% 70%, class:^(qt6ct)$"
          "size 70% 70%, class:^(evince|wihotspot(-gui)?)$"
          "size 60% 70%, class:^(file-roller|org.gnome.FileRoller)$"
          "size 60% 70%, class:^([Ww]hatsapp-for-linux)$"
          "size 60% 70%, class:^([Ff]erdium)$"

          # screen sharing
          "opacity 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "noinitialfocus, xwayland:1"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"
          "nofocus, class:^(xwaylandvideobridge)$"

          "unset, class:^(ueberzugpp.*)$"

          # Dialogs
          "float, title:(Select|Open)( a)? (File|Folder)(s)?"
          "float, title:File (Operation|Upload)( Progress)?"
          "float, title:.* Properties"
          "float, title:Export Image as PNG"
          "float, title:GIMP Crash Debug"
          "float, title:Save As"
          "float, title:Library"

          # Picture in picture (resize and move done via script)
          "move 100%-w-2% 100%-w-3%, title:Picture(-| )in(-| )[Pp]icture" # Initial move so window doesn't shoot across the screen from the center
          "keepaspectratio, title:Picture(-| )in(-| )[Pp]icture"
          "float, title:Picture(-| )in(-| )[Pp]icture"
          "pin, title:Picture(-| )in(-| )[Pp]icture"

          # Steam
          "rounding 10, title:, class:steam"
          "float, title:Friends List, class:steam"
          "immediate, class:steam_app_[0-9]+" # Allow tearing for steam games
          "idleinhibit always, class:steam_app_[0-9]+" # Always idle inhibit when playing a steam game

          # ATLauncher console
          "float, class:com-atlauncher-App, title:ATLauncher Console"

          # Autodesk Fusion 360
          "noblur, title:Fusion360|(Marking Menu), class:fusion360\.exe"

          # Ugh xwayland popups
          "nodim, xwayland:1, title:win[0-9]+"
          "noshadow, xwayland:1, title:win[0-9]+"
          "rounding 10, xwayland:1, title:win[0-9]+"

          # Bitwarden
          "float, class:Bitwarden,title:Bitwarden"
          "size 60% 70%, class:Bitwarden, title:Bitwarden"
          "noscreenshare, class:Bitwarden, title:Bitwarden"

          "float, class:com-group_finity-mascot-Main"
          "noblur, class:com-group_finity-mascot-Main"
          "nofocus, class:com-group_finity-mascot-Main"
          "noshadow, class:com-group_finity-mascot-Main"
          "noborder, class:com-group_finity-mascot-Main"

        ];
        layerrule = [

          # vicinae
          "blur, vicinae"
          "blurpopups, vicinae"
          "ignorealpha 0, vicinae"

          # blur
          # rofi
          "blur, rofi"
          # layerrule = unset, rofi
          "ignorezero, rofi"
          "blur, class:^(swww)$"

          # blur waybar
          # "blur, waybar"

          # blur swaync
          "blur, swaync-control-center"
          "blur, swaync-notification-window"
          "ignorezero, swaync-control-center"
          "ignorezero, swaync-notification-window"
          "ignorealpha, swaync-control-center"
          "ignorealpha, swaync-notification-window"

          # blur wlogout
          "blur, logout_dialog"
          "blur, gtk-layer-shell"

          # wezterm
          "blur, class:org.wezfurlong.wezterm"

          # ######## Layer rules ########
          "animation fade, hyprpicker" # Colour picker out animation
          "animation fade, logout_dialog" # wlogout
          "animation fade, selection" # slurp
          "animation fade, wayfreeze"

          # Fuzzel
          "animation popin 80%, launcher"
          "blur, launcher"

          # Shell
          "noanim, caelestia-(border-exclusion|area-picker)"
          "animation fade, caelestia-(drawers|background)"

          "blur, caelestia-drawers"
          "ignorealpha 0.57, caelestia-drawers"
        ];
      };
    };
  };
}

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
        "$windowOpacity" = 0.78;
        windowrule = [
          "opacity $windowOpacity override, match:fullscreen 0"

          "center on, match:float 1 match:xwayland 0" # Center all floating windows (not xwayland cause popups)

          # opacity
          "float on, match:class ^(io.github.kukuruzka165.materialgram|org.telegram.desktop)$, match:title 媒体查看器"

          # Float
          "float on, match:class guifetch" # FlafyDev/guifetch
          "float on, match:class yad"
          "float on, match:class zenity"
          "float on, match:class wev"
          "float on, match:class org\.gnome\.FileRoller"
          "float on, match:class file-roller" # WHY IS THERE TWOOOOOOOOOOOOOOOO
          "float on, match:class blueman-manager"
          "float on, match:class com\.github\.GradienceTeam\.Gradience"
          "float on, match:class feh"
          "float on, match:class system-config-printer"

          # windowrule Position
          "center on,match:class ^([Ww]hatsapp-for-linux)$"
          "center on,match:class ^([Ff]erdium)$"

          # filemanager
          "center on, match:class ([Tt]hunar), match:title ^([Tt]hunar)$, size 1200 1300"
          "center on, match:class ([Tt]hunar), match:title (Confirm to replace files)"
          "float on, match:class ^(org.gnome.Nautilus|thunar|pcmanfm|dolphin)$"
          "size 1145 672, match:class ^(org.gnome.Nautilus|thunar|pcmanfm|dolphin)$"
          "float on, match:class ([Tt]hunar), match:title (File Operation Progress)"
          "float on, match:class ([Tt]hunar), match:title (Confirm to replace files)"

          "float on, match:class sparkle, match:title Sparkle"
          "size 1250 1050, match:class sparkle, match:title Sparkle"
          "float on, match:class chromium-browser, match:title (雀魂麻将 - Chromium)"
          "float on, match:class ^(pot|.pot-wrapped)$, match:title (Translate|Translator|OCR|PopClip|Screenshot Translate|Config)" # Translation window floating
          "move cursor 0 0, match:class (pot|.pot-wrapped), match:title (Translator|PopClip|Screenshot Translate) "
          "float on, match:class (org.telegram.desktop), match:title (Media viewer)"
          "float on, match:title overskride"
          "float on, match:title QQ"
          "float on, match:title 图片查看器"

          "float on, match:class (VirtualBox)"
          "float on, match:class firefox,match:title (我的足迹)"
          "float on, match:class firefox,match:title 画中画"

          "float on, match:class (xfce4-appfinder)"
          "float on, match:class kitty, match:title yazi"
          "float on, match:class ^(gnome-)"
          "float on, match:class ([Zz]oom|onedriver|onedriver-launcher)$"

          "float on, match:class (xdg-desktop-portal-gtk)"
          "float on, match:class (org.gnome.Calculator), match:title (Calculator)"
          "float on, match:class (codium|codium-url-handler|VSCodium), match:title (Add Folder to Workspace)"
          "float on, match:class ^([Rr]ofi)$"
          "float on, match:class ^(eog|org.gnome.Loupe)$" # image viewer
          "float on, match:class ^(mpv|com.github.rafostar.Clapper)$"
          "size 70% 70%, match:class ^(mpv|com.github.rafostar.Clapper)$"

          "float on, match:class ^(nm-applet|nm-connection-editor|blueman-manager)$"
          "float on, match:class ^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" # system monitor
          "float on, match:class ^([Yy]ad)$"
          "float on, match:class ^(wihotspot(-gui)?)$" # wifi hotspot
          "float on, match:class ^(evince)$" # document viewer
          "float on, match:class ^(file-roller|org.gnome.FileRoller)$" # archive manager
          "float on, match:class ^([Bb]aobab|org.gnome.[Bb]aobab)$" # Disk usage analyzer
          "float on, match:title (Kvantum Manager)"
          "float on, match:class ^([Qq]alculate-gtk)$"
          "float on, match:class ^([Ff]erdium)$"

          "size 70% 70%, match:class ^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$"
          "size 70% 70%, match:class ^(xdg-desktop-portal-gtk)$"
          "size 60% 70%, match:title (Kvantum Manager)"
          "size 60% 70%, match:class ^(qt6ct)$"
          "size 70% 70%, match:class ^(evince|wihotspot(-gui)?)$"
          "size 60% 70%, match:class ^(file-roller|org.gnome.FileRoller)$"
          "size 60% 70%, match:class ^([Ww]hatsapp-for-linux)$"
          "size 60% 70%, match:class ^([Ff]erdium)$"

          # screen sharing
          "no_initial_focus on, match:xwayland 1"

          "group unset, match:class ^(ueberzugpp.*)$"

          # Dialogs
          "float on, match:title (Select|Open)( a)? (File|Folder)(s)?"
          "float on, match:title File (Operation|Upload)( Progress)?"
          "float on, match:title .* Properties"
          "float on, match:title Export Image as PNG"
          "float on, match:title GIMP Crash Debug"
          "float on, match:title Save As"
          "float on, match:title Library"

          # ATLauncher console
          "float on, match:class com-atlauncher-App, match:title ATLauncher Console"

          # Autodesk Fusion 360
          "no_blur on, match:title Fusion360|(Marking Menu), match:class fusion360\.exe"

          # This not gonna take the focus to the window that appears when hovering over some of the parts of the IntelliJ Products"
          "no_initial_focus on,  match:class ^(.*jetbrains.*)$, match:title ^(win[0-9]+)$"

        ];
        layerrule = [

          # ######## Layer rules ########
          "animation fade, match:namespace hyprpicker" # Colour picker out animation
          # "animation fade, logout_dialog" # wlogout
          "animation fade, match:namespace selection" # slurp
          # "animation fade, wayfreeze"

          # Fuzzel
          # "animation popin 80%, launcher"
          # "blur, launcher"
        ];
      };
      extraConfig = ''
        # ========= tools =========
        windowrule {
            name = imv-took
            match:class = imv|equibop|swappy

            float = on
            opaque = on
        }

        # ====== gnome ============ 
        windowrule {
            name = gnome-settings
            match:class = org\.gnome\.Settings

            float = on
            size = 70% 80%
            center = on
        }
        windowrule {
            name = pulseaudio
            match:class = org\.pulseaudio\.pavucontrol|yad-icon-browser

            float = on
            size = 60% 70%
            center = on
        }
        windowrule {
            name = nwg-look
            match:class = nwg-look

            float = on
            size = 50% 60%
            center = on
        }

        windowrule {
            name = flameshot
            match:class = flameshot

            pin = on
            move = 0 0
            suppress_event = fullscreen
        }
        windowrule = float on, match:class (flameshot) match:title (flameshot-pin)

        # screen sharing
        windowrule {
            name = screen_sharing
            match:class = xwaylandvideobridge

            opacity = 0.0 override
            no_anim = on
            no_initial_focus = on
            max_size = 1 1
            no_blur = on
            no_focus = on
        }

        # Picture in picture (resize and move done via script)
        windowrule {
            name = picture_in_picture
            match:title = Picture(-| )in(-| )[Pp]icture

            float = on
            pin = on
            keep_aspect_ratio = on
            move = 100%-w-2% 100%-w-3%
        }

        windowrule {
            name = steam_app
            match:class = steam_app_[0-9]+

            rounding = 10
            float = on
            immediate = on
            idle_inhibit = always
        }
        windowrule = float on, match:class steam match:title \"Friends List\"

        # Bitwarden
        windowrule {
            name = Bitwarden-rule
            match:class = Bitwarden
            match:title = Bitwarden

            float = on
            size = 60% 70%
            no_screen_share = on
        }

        # Ugh xwayland popups
        windowrule {
            name = xwayland-title
            match:xwayland = 1
            match:title = "win[0-9]+"

            no_dim = on
            no_shadow = on
            rounding = 10
        }

        windowrule {
            name = com-group_finity-mascot-Main
            match:class = com-group_finity-mascot-Main

            float = on
            no_blur = on
            no_focus = on
            no_shadow = on
            border_size = 0
        }
      '';
    };
  };
}

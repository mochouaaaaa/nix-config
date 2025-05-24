{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [

          # windowrule Position
          "center,class:^(pavucontrol|pavucontrol-qt|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)"
          "center,class:^([Ww]hatsapp-for-linux)$"
          "center,class:^([Ff]erdium)$"
          "move 0 0,title:^(flameshot)"
          "pin, class:^(flameshot)$"
          "suppressevent fullscreen,title:^(flameshot)"

          "center, class:([Tt]hunar), title:^([Tt]hunar)$, size: 1200,1300"
          "center, class:([Tt]hunar), title:(Confirm to replace files)"
          "center, title:^(ROG Control)$"
          "center, title:^(Keybindings)$"
          "move 72% 7%,title:^(Picture-in-Picture)$"

          # windowrule v2 to avoid idle for fullscreen apps
          # windowrule = idleinhibit fullscreen, class:^(*)$
          # windowrule = idleinhibit fullscreen, title:^(*)$
          "idleinhibit fullscreen, fullscreen:1"

          # windowrule  - float
          "float, class:(pot|.pot-wrapped), title:(Translate|Translator|OCR|PopClip|Screenshot Translate)" # Translation window floating
          "float, class:(flameshot), title:(flameshot-pin)"
          "float, class:(org.telegram.desktop), title:(Media viewer)"
          "float, title:overskride"
          "float, title:QQ"
          "float, title:图片查看器"
          "float, class:^(org.gnome.Nautilus|thunar|pcmanfm|dolphin)$"
          "float, class:(VirtualBox)"
          "float, class:firefox,title:(我的足迹)"
          "float, class:Bitwarden,title:Bitwarden"
          "float, class:(xfce4-appfinder)"
          "float, class:kitty,title:yazi"
          "float, class:^(gnome-)"
          "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "float, class:([Zz]oom|onedriver|onedriver-launcher)$"
          "float, class:([Tt]hunar), title:(File Operation Progress)"
          "float, class:([Tt]hunar), title:(Confirm to replace files)"
          "float, class:(xdg-desktop-portal-gtk)"
          "float, class:(org.gnome.Calculator), title:(Calculator)"
          "float, class:(codium|codium-url-handler|VSCodium), title:(Add Folder to Workspace)"
          "float, class:^([Rr]ofi)$"
          "float, class:^(eog|org.gnome.Loupe)$" # image viewer
          "float, class:^(pavucontrol|pavucontrol-qt|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
          "float, class:^(nwg-look|qt5ct|qt6ct)$"
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
          "float, title:^(Picture-in-Picture)$"
          "float, title:^(ROG Control)$"

          # windowrule v2 - opacity #enable as desired
          "opacity 0.9 0.6, class:^([Rr]ofi)$"
          "opacity 0.9 0.7, class:^(Brave-browser(-beta|-dev)?)$"
          "opacity 0.9 0.7, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
          "opacity 0.9 0.7, class:^(zen-alpha)$" # zen browser
          "opacity 0.9 0.6, class:^([Tt]horium-browser)$"
          "opacity 0.9 0.8, class:^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$"
          "opacity 0.9 0.8, class:^(google-chrome(-beta|-dev|-unstable)?)$"
          "opacity 0.94 0.86, class:^(chrome-.+-Default)$" # Chrome PWAs
          "opacity 0.9 0.8, class:^([Tt]hunar|org.gnome.Nautilus)$"
          "opacity 0.8 0.6, class:^(pcmanfm-qt)$"
          "opacity 0.8 0.7, class:^(gedit|org.gnome.TextEditor|mousepad)$"
          "opacity 0.9 0.8, class:^(deluge)$"
          "opacity 0.8 0.7, class:^(Alacritty|kitty|kitty-dropterm)$" # Terminals
          "opacity 0.9 0.7, class:^(VSCodium|codium-url-handler)$"
          "opacity 0.9 0.8, class:^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"
          "opacity 0.9 0.8, title:(Kvantum Manager)"
          "opacity 0.9 0.7, class:^(com.obsproject.Studio)$"
          "opacity 0.9 0.7, class:^([Aa]udacious)$"
          "opacity 0.9 0.8, class:^(VSCode|code-url-handler)$"
          "opacity 0.9 0.8, class:^(jetbrains-.+)$" # JetBrains IDEs
          "opacity 0.94 0.86, class:^([Dd]iscord|[Vv]esktop)$"
          "opacity 0.9 0.8, class:^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$"
          "opacity 0.9 0.8, class:^(im.riot.Riot)$ # Element matrix client"
          "opacity 0.94 0.86, class:^(gnome-disks|evince|wihotspot(-gui)?|org.gnome.baobab)$"
          "opacity 0.9 0.8, class:^(file-roller|org.gnome.FileRoller)$" # archive manager
          "opacity 0.8 0.7, class:^(app.drey.Warp)$" # Warp file transfer
          "opacity 0.9 0.8, class:^(seahorse)$" # gnome-keyring gui
          "opacity 0.82 0.75, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$"
          "opacity 0.9 0.8, class:^(xdg-desktop-portal-gtk)$" # gnome-keyring gui
          "opacity 0.9 0.7, class:^([Ww]hatsapp-for-linux)$"
          "opacity 0.9 0.7, class:^([Ff]erdium)$"
          "opacity 0.95 0.75, title:^(Picture-in-Picture)$"

          # windowrule v2 - size
          "size 50% 60%, class:^(pavucontrol|pavucontrol-qt|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)"
          "size 70% 70%, class:^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$"
          "size 70% 70%, class:^(xdg-desktop-portal-gtk)$"
          "size 60% 70%, title:(Kvantum Manager)"
          "size 60% 70%, class:^(qt6ct)$"
          "size 70% 70%, class:^(evince|wihotspot(-gui)?)$"
          "size 60% 70%, class:^(file-roller|org.gnome.FileRoller)$"
          "size 60% 70%, class:^([Ww]hatsapp-for-linux)$"
          "size 60% 70%, class:^([Ff]erdium)$"
          "size 25% 25%, title:^(Picture-in-Picture)$"
          "size 60% 70%, title:^(ROG Control)$"
          #size 25% 25%, title:^(Firefox)$
          "size 60% 70%, class:Bitwarden, title:Bitwarden"

          # windowrule v2 - pinning
          "pin,title:^(Picture-in-Picture)$"
          # pin,title:^(Firefox)$"

          #windowrule = bordercolor rgb(EE4B55) rgb(880808), fullscreen:1"
          #windowrule = bordercolor rgb(282737) rgb(1E1D2D), floating:1
          #windowrule = opacity 0.8 0.8, pinned:1"

          # LAYER RULES
          #layerrule = unset,class:^([Rr]ofi)$
          #layerrule = blur,class:^([Rr]ofi)$
          #layerrule = ignorezero, <rofi>
          #layerrule = ignorezero, overview
          #layerrule = blur, overview

          # plugnis
          "plugin:chromakey,fullscreen:0"
          # chromakey_background = 7,8,17

          # screen sharing
          "opacity 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"
          "nofocus, class:^(xwaylandvideobridge)$"

          # neovide
          "opacity 0.8 0.8, class:^(neovide)$"
          "unset, class:^(ueberzugpp.*)$"

          # wiliwili
          "float, title:wiliwili"

        ];
        layerrule = [
          #neovide
          "blur, class:^(neovide)$"

          # blur
          # rofi
          "blur, rofi"
          # layerrule = unset, rofi
          "ignorezero, rofi"
          "blur, class:^(swww)$"

          # blur waybar
          "blur, waybar"

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
        ];
      };
    };
  };
}

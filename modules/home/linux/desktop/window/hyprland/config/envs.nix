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
        env = [
          "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
          "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
          "MOZ_WEBRENDER,1"

          # environment-variables
          "CLUTTER_BACKEND,wayland"
          "SDL_VIDEODRIVER,wayland"
          "GDK_BACKEND,wayland,x11,*"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_QPA_PLATFORM,wayland;xcb"
          "GDK_DPI_SCALE,1"
          "QT_SCALE_FACTOR,1"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"

          # fcitx5
          "XMODIFIERS,@im=fcitx"
          "QT_IM_MODULE,wayland"

          #java
          "_JAVA_AWT_WM_NONREPARENTING,1"

          # firefox
          "MOZ_ENABLE_WAYLAND,1"
          "MOZ_WEBRENDER,1"

          # electron >28 apps (may help)
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
        ];
      };
    };
  };
}

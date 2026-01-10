{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        env = [
          "XCURSOR_SIZE,${toString config.home.pointerCursor.size}"

          "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland

          # Toolkit Backend
          # "GDK_BACKEND,wayland,x11,*"
          "CLUTTER_BACKEND,wayland"
          "QT_QPA_PLATFORM,wayland"
          "SDL_VIDEODRIVER,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"

          # environment-variables
          "GDK_DPI_SCALE,1"

          # # XDG Desktop Portal
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"

          # QT
          # "QT_QPA_PLATFORMTHEME,qt6ct"
          # "QT_QPA_PLATFORMTHEME,qt5ct"
          "QT_QPA_PLATFORMTHEME,gtk3"
          "QT_QPA_PLATFORMTHEME_QT6,gtk3"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_IM_MODULE,fcitx"

          # fcitx5
          "XMODIFIERS,@im=fcitx"
          "QT_IM_MODULE,wayland"

          #java
          "_JAVA_AWT_WM_NONREPARENTING,1"

          # firefox
          "MOZ_ENABLE_WAYLAND,1"
          "MOZ_WEBRENDER,1"

          # Ozone
          "OZONE_PLATFORM,wayland"

          # KVM
          "WLR_RENDERER_ALLOW_SOFTWARE, 1"
        ];
      };
    };
  };
}

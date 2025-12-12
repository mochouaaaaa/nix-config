{ config, lib, ... }:
let

  cfg = config.modules'.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {

    programs.niri.settings = {
      environment = {
        # theme
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_QPA_PLATFORMTHEME_QT6 = "gtk3";

        #environment-variables
        CLUTTER_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland";
        # GDK_DPI_SCALE = "1";
        # QT_SCALE_FACTOR = "1";
        # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";

        "DISPLAY" = ":0";
        MOZ_ENABLE_WAYLAND = "1";

        # java
        _JAVA_AWT_WM_NONREPARENTING = "1";

        # firefox
        NIXOS_OZONE_WL = "1";
        MOZ_WEBRENDER = "1";

        # electron >28 apps (may help)
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
    };
  };
}

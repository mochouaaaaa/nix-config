{ lib, config, ... }:
let
  cfg = config.profiles.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.home.homeDirectory}/.current_wallpaper";
        picture-uri-dark = "file://${config.home.homeDirectory}/.current_wallpaper";
      };
      "org/gnome/gnome-session" = {
        auto-save-session = true;
        auto-save-session-one-shot = true;
      };
      # monitor
      "org/gnome/desktop/session" = {
        idle-delay = lib.gvariant.mkUint32 600;
      };
      "org/gnome/desktop/applications/terminal" = {
        exec = "kitty --single-instance";
      };
      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.gvariant.mkUint32 200;
        repeat-interval = lib.gvariant.mkUint32 40;
      };
    };

  };
}

{ lib, config, ... }:
{
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
      exec = "kitty";
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.gvariant.mkUint32 250;
      repeat-interval = lib.gvariant.mkUint32 26;
    };
  };
}

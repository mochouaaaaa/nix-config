{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    home.packages = [
      pkgs.gedit
    ];

    dconf.settings = {
      "org/gnome/gedit/preferences/editor" = {
        auto-save = true;
        display-right-margin = true;
        editor-font = "Monaco Nerd Font Mono 12";
        right-margin-position = lib.hm.gvariant.mkUint32 120;
        tabs-size = lib.hm.gvariant.mkUint32 4;
        use-default-font = false;
        wrap-last-split-mode = "word";
      };
    };

  };
}

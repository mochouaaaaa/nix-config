{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop;
in
{

  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    environment.systemPackages = with pkgs; [
      turtle # nautilus plugin git operation
      nautilus
    ];

    programs = {
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

  };
}

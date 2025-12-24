{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop;
  gnomeSeries = cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable;
in
{

  config = lib.mkIf gnomeSeries {

    environment.systemPackages = with pkgs; [
      turtle # nautilus plugin git operation
      nautilus
    ];

    services.gnome.sushi.enable = true;

    programs = {
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

  };
}

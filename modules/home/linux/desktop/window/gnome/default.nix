{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.gnome;

in
{
  imports = [
    ./config
    ./component
  ];

  options.modules.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "gnome";
      description = "Enable GNOME desktop environment.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xremap.withGnome = lib.mkForce true;

    modules.themes.auto = {
      enable = true;
      gtkTheme.enable = true;
    };

    programs.gnome-shell = {
      enable = true;
    };

  };
}

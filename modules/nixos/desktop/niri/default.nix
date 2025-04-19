{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgNiri = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "niri";
      description = "Enable Niri, a lightweight and fast desktop environment for Linux.";
    };
  };

  config = lib.mkIf cfgNiri.enable {
    modules.dm.greetd.enable = true;
    modules.desktop = {
      # hyprland.enable = lib.mkForce false;
      # gnome.enable = lib.mkForce false;
      # kde.enable = lib.mkForce false;
    };

    services = {
      xserver = {
        enable = true;
      };
      greetd = {
        settings = {
          default_session = {
            command = lib.mkForce "${lib.getExe config.programs.niri.package}";
          };
        };
      };
    };
  };
}

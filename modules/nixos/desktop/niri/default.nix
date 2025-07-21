{
  self,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfgNiri = config.modules.desktop.niri;
in
{
  imports = lib.importModule' ./.;

  options.modules.desktop.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "niri";
      description = "Enable Niri, a lightweight and fast desktop environment for Linux.";
    };
  };

  config = lib.mkIf cfgNiri.enable {

    modules.dm.greetd.enable = true;
    # modules.dm.gdm.enable = true;

    services = {
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
      };
      xserver = {
        enable = true;
      };
      greetd = {
        settings = {
          default_session = {
            command = lib.mkForce "${lib.getExe' pkgs.niri "niri-session"}";
          };
        };
      };
    };
  };
}

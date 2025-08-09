{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgNiri = config.modules'.desktop.niri;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf cfgNiri.enable {

    modules.dm.greetd.enable = true;

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

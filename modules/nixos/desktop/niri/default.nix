{
  config,
  lib,
  pkgs,
  username,
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
      greetd = {
        settings = rec {
          default_session = {
            user = username;
            command = lib.mkForce "${lib.getExe' pkgs.niri "niri-session"}";
          };
          initial_session = default_session;
        };
      };
    };
  };
}

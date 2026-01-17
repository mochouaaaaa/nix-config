{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfgNiri = config.profiles.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

    profiles.display-manager.greetd.enable = true;

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

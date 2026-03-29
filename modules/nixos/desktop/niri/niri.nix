{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgNiri = config.profiles.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

    profiles.display-manager.greetd = {
      enable = true;
      command = "niri-session";
    };

  };
}

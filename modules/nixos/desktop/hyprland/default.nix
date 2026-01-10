{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}:
let
  cfgHyprland = config.profiles.desktop.hyprland;
in
{

  config = lib.mkIf cfgHyprland.enable {

    modules.display-manager.greetd.enable = true;

    services = {
      greetd = {
        settings = rec {
          default_session = {
            user = username;
            command = lib.mkForce "start-hyprland";
          };
          initial_session = default_session;
        };
      };
    };
  };
}

{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf cfgHyprland.enable {

    modules.dm.greetd.enable = true;

    programs.ssh.startAgent = lib.mkForce false;

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

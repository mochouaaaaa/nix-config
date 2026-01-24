{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
  cfghyprland = config.programs.hyprland;
in
{

  imports = [ inputs.hyprland.nixosModules.default ];

  config = lib.mkIf cfg.enable {

    profiles.display-manager.greetd = {
      enable = true;
      command = "start-hyprland";
    };

    programs.hyprland = {
      enable = true;
      # FIX: home-manager env unload
      withUWSM = false;
    };

    profiles.persistent.hmDirectories = lib.optionals cfghyprland.withUWSM [
      ".config/uwsm"
    ];

    home-manager.sharedModules = [
      (
        { config, ... }:
        {

          config = lib.mkIf cfghyprland.enable (
            lib.mkMerge [

              {
                wayland.windowManager.hyprland = {
                  package = lib.mkForce null;
                  portalPackage = lib.mkForce null;
                  systemd.enable = lib.mkForce (!cfghyprland.withUWSM);
                };

                xdg.portal.extraPortals = [ cfghyprland.portalPackage ];
              }

              (lib.mkIf cfghyprland.withUWSM {
                wayland.systemd.target = lib.mkForce "graphical-session.target";

                xdg.configFile."uwsm/env" = {
                  enable = true;
                  source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
                };
              })

            ]
          );

        }
      )
    ];

  };
}

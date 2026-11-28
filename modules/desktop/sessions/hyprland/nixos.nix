{ inputs, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.hyprland" = {
      includes = [
        aspects."desktop.common"
        (inputs.flake-aspects.lib.forward {
          each = [ { userName = "mochou"; } ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = user: [ "home-manager" "users" user.userName ];
          fromAspect = _: aspects."desktop.hyprland";
        })
      ];

      nixos =
        {
          lib,
          pkgs,
          inputs,
          config,
          username,
          ...
        }:
        let
          nixosHyprland = config.programs.hyprland;
        in
        {
          programs.hyprland = {
            enable = true;
            # package = pkgs.hyprland;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage =
              inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
            withUWSM = true;
          };

          services.displayManager.noctalia-greeter.settings.session.default = "hyprland-uwsm";

          # Keep the NixOS-dependent Home Manager compatibility adjustments here.
          home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
            (
              { lib, config, ... }:
              {
                config = lib.mkIf nixosHyprland.enable (
                  lib.mkMerge [
                    {
                      wayland.windowManager.hyprland = {
                        package = lib.mkForce null;
                        portalPackage = lib.mkForce null;
                        systemd.enable = lib.mkForce (!nixosHyprland.withUWSM);
                      };

                      xdg.portal.extraPortals = [ nixosHyprland.portalPackage ];
                    }

                    (lib.mkIf nixosHyprland.withUWSM {
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
    };
  };
}

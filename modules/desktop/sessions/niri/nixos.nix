{ inputs, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.niri" = {
      includes = [
        aspects."desktop.common"
        (inputs.flake-aspects.lib.forward {
          each = [ { userName = "mochou"; } ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = user: [ "home-manager" "users" user.userName ];
          fromAspect = _: aspects."desktop.niri";
        })
      ];

      nixos =
        {
          config,
          lib,
          username,
          ...
        }:
        let
          nixosNiri = config.programs.niri;
        in
        {
          programs.niri = {
            enable = true;
            useNautilus = true;
          };

          programs.uwsm.waylandCompositors = {
            niri = {
              prettyName = "Niri";
              comment = "Niri compositor managed by UWSM";
              binPath = "${lib.getExe' config.programs.niri.package "niri-session"}";
            };
          };
          services.displayManager.noctalia-greeter.settings.session.default = "niri-uwsm";

          # Keep the NixOS-dependent Home Manager compatibility adjustments here.
          home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
            ({ lib, ... }: {
              wayland.windowManager.niri = {
                package = lib.mkForce nixosNiri.package;
                systemd.enable = false;
              };
            })
          ];
        };
    };
  };
}

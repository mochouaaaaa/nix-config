{
  flake.aspects = { aspects, ... }: {
    "desktop.niri" = {
      includes = [
        aspects."desktop.common"
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

          # The desktop Home Manager aspect is forwarded by the Host configuration.
          # Keep only the NixOS-dependent compatibility adjustments here.
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

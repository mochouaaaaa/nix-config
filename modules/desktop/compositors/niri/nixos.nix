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
          self,
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

          # Compose the matching Home Manager desktop only for the primary user.
          home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
            self.modules.homeManager."desktop.niri"
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

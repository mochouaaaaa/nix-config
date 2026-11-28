{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.base" = {
      includes = [
        aspects."security.desktop"
        aspects.appearance
      ];

      nixos =
        { pkgs, ... }:
        {
          services.geoclue2.enable = true;

          environment.systemPackages = [ pkgs.uwsm ];

          # Enable the system portal service; Home Manager supplies the user's
          # compositor-specific portal configuration and backend packages.
          xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          };
        };
    };
  };
}

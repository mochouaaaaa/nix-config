{ self, ... }:
{
  flake.aspects = { ... }: {
    "desktop.base" = {
      # These modules have not been migrated to aspects yet; keep them as
      # an inline dependency until their owning modules are converted.
      includes = [
        {
          nixos.imports = [
            self.modules.nixos.appearance
            self.modules.nixos."security.desktop"
          ];
        }
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

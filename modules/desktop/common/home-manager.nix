{
  flake.aspects.desktop-base.nixos =
    { lib, config, ... }:
    {
      config = lib.mkIf (config ? home-manager && config.home-manager.useUserPackages) {
        environment.pathsToLink = [
          "/share/xdg-desktop-portal"
          "/share/applications"
        ];
      };
    };
}

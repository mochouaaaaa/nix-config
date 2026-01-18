{ lib, config, ... }:
{

  config = lib.mkMerge [
    (lib.mkIf config.home-manager.useUserPackages {
      environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    })
  ];

}

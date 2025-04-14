{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        config = {
          hyprland = {
            default = [ "hyprland" ] ++ (config.xdg.config.common.default or [ ]);
          };
        };
      };
      configFile = {
        "autostart/clas_verge.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Version=1.0
          Name=Clash Verge
          Comment=Clash Vergestartup script
          Exec=${pkgs.clash-verge-rev}/bin/clash-verge
          StartupNotify=false
          Terminal=false
        '';
        "autostart/clas_verge_service.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Version=1.0
          Name=Clash Verge Service
          Comment=Clash Vergestartup script
          Exec=${pkgs.clash-verge-rev}/bin/clash-verge-service
          StartupNotify=false
          Terminal=false
        '';

      };
    };
  };
}

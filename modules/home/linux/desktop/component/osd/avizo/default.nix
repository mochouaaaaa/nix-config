{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfgDesktop = config.modules'.desktop;
in
{
  config = lib.mkIf (cfgDesktop.hyprland.enable || cfgDesktop.niri.enable) {

    home.packages = with pkgs; [
      avizo
    ];

    xdg.configFile = {
      "avizo/config.ini".text = ''
        [default]
        time = 3.0
      '';
    };

    systemd.user.services.avizo = {
      Unit = {
        Description = "Avizo Server (OSD HUD for volume/brightness)";
        After = lib.mkMerge [
          (lib.mkIf cfgDesktop.hyprland.enable [ "hyprland-session.target" ])
          (lib.mkIf cfgDesktop.niri.enable [ "niri.service" ])
        ];
      };
      Service = {
        ExecStart = "${pkgs.avizo}/bin/avizo-service";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = lib.mkMerge [
          (lib.mkIf cfgDesktop.hyprland.enable [ "hyprland-session.target" ])
          (lib.mkIf cfgDesktop.niri.enable [ "niri.service" ])
        ];
      };
    };

  };
}

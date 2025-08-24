{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    modules'.shortcuts.global = [
      {
        "SUPER-SPACE" = {
          launch = [
            "bash"
            "-c"
            "${lib.getExe pkgs.albert} toggle"
          ];
        };
      }
    ];

    systemd.user.services.albert = {
      Unit = {
        Description = "Albert Service";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${lib.getExe pkgs.albert}  --platform xcb";
        Restart = "on-failure";
        RestartSec = "5s";
        TimeoutStopSec = "5s";
        Slice = "session.slice";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}

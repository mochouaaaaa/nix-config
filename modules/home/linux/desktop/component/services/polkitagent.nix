{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.services.polkitagent;
in
{
  options.modules'.desktop.services.polkitagent = {
    enable = lib.mkEnableOption "polkit agent";
  };

  config = lib.mkIf cfg.enable {

    systemd.user.services.polkitagent = {
      Unit = {
        Description = "Polkit Agent";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop;
in
{
  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable) {

    systemd.user.services.polkitagent = {
      Unit = {
        Description = "Polkit Agent";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };

}

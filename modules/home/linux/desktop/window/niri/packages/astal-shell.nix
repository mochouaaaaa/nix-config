{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {

    programs.ags = {
      enable = lib.mkForce true;
      configDir = null; # Don't symlink since we're using the bundled version
      extraPackages = with pkgs; [
        inputs.astal-shell.packages.${pkgs.system}.default
      ];
    };

    systemd.user.services.astal-shell = {
      Unit = {
        Description = "Astal Shell";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${inputs.astal-shell.packages.${pkgs.system}.default}/bin/astal-shell";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}

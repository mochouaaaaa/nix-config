{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.shell.noctalia;
in
{

  config = lib.mkIf (cfg.enable) {

    services.darkman.enable = lib.mkForce false;

    modules'.themes.auto = {
      enable = false;
      gtkTheme = {
        enable = true;
        # shellTheme = "${lib.getExe config.programs.noctalia-shell.package} ipc call darkMode setLight";
      };
    };

  };
}

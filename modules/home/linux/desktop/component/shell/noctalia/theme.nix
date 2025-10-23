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
      enable = true;
      gtkTheme = {
        enable = true;
        shellTheme = "${
          lib.getExe inputs.noctalia.packages.${pkgs.system}.default
        } ipc call darkMode setLight";
      };
    };

  };
}

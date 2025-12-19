{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.shell.dankMaterialShell;
in
{

  config = lib.mkIf (cfg.enable) {

    modules'.themes.auto = {
      enable = true;
      gtkTheme = {
        enable = true;
        # shellTheme = "${config.systemd.user.services.dms.Service.ExecStart} ipc call theme light";
      };
    };

  };
}
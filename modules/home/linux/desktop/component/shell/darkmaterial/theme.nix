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

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          dms ipc call theme light
          switch-theme Light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          dms ipc call theme dark
          switch-theme Dark
        '';
      };
    };

  };
}

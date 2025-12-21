{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules'.desktop.shell.dankMaterialShell;
  cfgDesktop = config.modules'.desktop;
in
{
  imports = lib.importModule ./. ++ [
    inputs.DankMaterialShell.homeModules.dankMaterialShell.default
  ];

  options.modules'.desktop.shell.dankMaterialShell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable DankMaterialShell";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.dankMaterialShell = {
      enable = true;
      systemd.enable = true;
    };

    systemd.user.services.dms = {
      Service = {
        Environment = [
          "DMS_HIDE_TRAYIDS=udiskie"
        ];
      };
    };
  };

}

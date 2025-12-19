{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.shell.dankMaterialShell;
in
{
  imports = lib.importModule' ./. ++ [
    inputs.DankMaterialShell.homeModules.dankMaterialShell.default
  ];

  options.modules'.desktop.shell.dankMaterialShell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia's Hyprland module";
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
{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.shell.dankMaterialShell;
  # cfgDesktop = config.profiles.desktop;
in
{
  imports = [
    inputs.DankMaterialShell.homeModules.dankMaterialShell.default
  ];

  options.profiles.desktop.shell.dankMaterialShell = {
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

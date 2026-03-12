{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.shell.dank-material-shell;
in
{
  imports = [
    inputs.dank-material-shell.homeModules.dank-material-shell
  ];

  options.profiles.desktop.shell.dank-material-shell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable DankMaterialShell";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.dank-material-shell = {
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

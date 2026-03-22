{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.shell.caelestia;
in
{

  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  options.profiles.desktop.shell.caelestia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable caelestia Shell integration";
    };
  };

  config = lib.mkIf (cfg.enable) {

    programs.caelestia = {
      enable = true;
      cli = {
        enable = true;
      };
      systemd = {
        environment = [ "QT_QPA_PLATFORMTHEME=gtk3" ];
      };
    };

  };
}

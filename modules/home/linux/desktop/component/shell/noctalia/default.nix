{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.shell.noctalia;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
  cfgDesktop = config.modules'.desktop;
in
{

  imports = lib.importModule' ./. ++ [
    inputs.noctalia.homeModules.default
  ];

  options.modules'.desktop.shell.noctalia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia's Noctalia Shell module";
    };
    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "configuration value";
            };
        in
        valueType;
      default = { };
    };
  };

  config = lib.mkIf (cfg.enable) {

    home.packages = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    services.cliphist.enable = lib.mkForce false;

    systemd.user.services = {
      noctalia-shell = {
        Service = {
          Environment = [
            "QT_QPA_PLATFORMTHEME=gtk3"
            "QT_QPA_PLATFORM=wayland"
          ];
        };
      };
    };

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      settings = cfgNoctalia.settings;
    };
  };
}

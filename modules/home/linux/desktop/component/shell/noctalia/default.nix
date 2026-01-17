{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.shell.noctalia;
  noctalia-shell = (
    pkgs.noctalia-shell.override {
      calendarSupport = true;
    }
  );
in
{

  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.profiles.desktop.shell.noctalia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia's Noctalia Shell module";
    };
  };

  config = lib.mkIf (cfg.enable) {

    home.packages = [
      noctalia-shell
    ];

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
      package = noctalia-shell;
      systemd.enable = true;
    };
  };
}

{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.shell.noctalia;
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
      # (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      #   calendarSupport = true;
      # })
      (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default)

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
      systemd.enable = true;
    };
  };
}

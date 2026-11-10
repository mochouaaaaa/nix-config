{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.desktop.shell.noctalia;
in
{

  options.profiles.desktop.shell.noctalia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia's Noctalia Shell module";
    };
  };

  config = lib.mkIf (cfg.enable) {

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

  };
}

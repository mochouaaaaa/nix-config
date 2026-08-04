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

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        accessibility = {
          high_contrast = false;
          ui_scale = 1.0;
        };
        shell = {
          clipboard_enabled = false;
          clipboard_keep_from_closed_apps = false;
          polkit_agent = true;
          popup_shadows = false;
          screenshot = {
            confirm_region = true;
            remember_last_region = true;
          };
          greeter_sync = {
            auto_sync = false;
          };
        };
      };
    };
  };
}

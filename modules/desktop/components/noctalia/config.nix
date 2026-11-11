{

  flake.modules.homeManager."desktop.shell.noctalia" = { lib, ... }: {

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

    services.blueman-applet.enable = lib.mkForce false;
    services.network-manager-applet.enable = lib.mkForce false;

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        accessibility = {
          high_contrast = false;
          ui_scale = 1.0;
        };
        audio = {
          enable_overdrive = false;
          enable_sounds = false;
          notification_sound = "";
          sound_volume = 0.5;
          volume_change_sound = "";
        };
        location = {
          address = "北京";
          auto_locate = false;
          custom_schedule = false;
          longitude = 39.9042;
          sunrise = "";
          sunset = "";
        };
      };
    };

  };

}

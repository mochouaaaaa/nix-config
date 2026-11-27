{

  flake.aspects."desktop.shell.noctalia".homeManager = { lib, ... }: {

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
        desktop_widgets = {
          enabled = false;
        };
        control_center = {
          sidebar = "full";
          sidebar_section = "full";
        };
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

  flake.aspects.preservation.nixos =
    {
      lib,
      config,
      options,
      username,
      ...
    }:
    let
      hasHM = options ? home-manager;
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (hasHM && config.home-manager.users.${username}.programs.noctalia.enable)
          [
            # ".cache/noctalia"
            ".local/state/noctalia/chromium-based"
            ".local/state/noctalia/clipboard"
            ".local/state/noctalia/community-palettes"
            ".local/state/noctalia/community-templates"
            ".local/state/noctalia/notification_history_assets"
            ".local/state/noctalia/plugin-cache"
            ".local/state/noctalia/plugins"
          ];
    };

}

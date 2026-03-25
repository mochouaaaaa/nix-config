{
  pkgs,
  lib,
  config,
  themeNameWithMode,
  ...
}:
let
  cfg = config.services.vicinae;
in
{

  config = lib.mkIf (cfg.enable) {

    profiles.shortcuts.global = [
      {
        "SUPER-SPACE" = {
          launch = [
            "bash"
            "-c"
            "vicinae toggle"
          ];
        };
        "SUPER-p" = {
          launch = [
            "bash"
            "-c"
            "vicinae vicinae://launch/clipboard/history"
          ];
        };
      }
    ];

    services.vicinae = {
      package = pkgs.vicinae;
      systemd = {
        enable = true;
        environment = {
          USE_LAYER_SHELL = 1;
          # QT_SCALE_FACTOR = 1;
          QT_QPA_PLATFORMTHEME = "gtk3";
        };
        target = config.wayland.systemd.target;
      };
      themes = {
      };
      settings = {
        close_on_focus_loss = true;
        consider_preedit = true;
        pop_to_root_on_close = true;
        favicon_service = "twenty";
        search_files_in_root = true;
        escape_key_behavior = "escape_key_behavior";
        font = {
          normal = {
            size = 12;
            family = "${config.profiles.fonts.default}";
          };
        };
        theme = {
          light = {
            name = "vicinae-light";
            icon_theme = "${themeNameWithMode config.profiles.themes.gtkTheme.icon.name config.profiles.themes.gtkTheme.icon.light}";
          };
          dark = {
            name = "vicinae-dark";
            icon_theme = "${themeNameWithMode config.profiles.themes.gtkTheme.icon.name config.profiles.themes.gtkTheme.icon.dark}";
          };
        };
        providers = {
          applications = {
            preferences = {
              launchPrefix = "uwsm app --";
            };
          };
        };
        launcher_window = {
          opacity = 0.78;
          dim_around = false;
          blur = {
            enabled = false;
          };
        };
      };
    };

  };
}

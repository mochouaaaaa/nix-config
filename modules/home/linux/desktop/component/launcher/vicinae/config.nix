{
  lib,
  pkgs,
  inputs,
  config,
  themeNameWithMode,
  ...
}:
let
  cfg = config.programs.vicinae;
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

    programs.vicinae = {
      systemd = {
        enable = true;
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        nix
        github
      ];
      mutableSettings = true;
      settings = {
        close_on_focus_loss = true;
        consider_preedit = true;
        pop_to_root_on_close = true;
        activate_on_single_click = true;
        encrypt_sensitive_data = true;
        favicon_service = "twenty";
        search_files_in_root = true;
        escape_key_behavior = "escape_key_behavior";
        global_shortcuts = {
          toggle = "";
        };
        font = {
          rendering = "native";
          normal = {
            size = 12;
            family = "${config.profiles.fonts.default}";
          };
        };
        theme = {
          light = {
            name = "noctalia";
            icon_theme = "${themeNameWithMode config.profiles.themes.gtkTheme.icon.name config.profiles.themes.gtkTheme.icon.light}";
          };
          dark = {
            name = "noctalia";
            icon_theme = "${themeNameWithMode config.profiles.themes.gtkTheme.icon.name config.profiles.themes.gtkTheme.icon.dark}";
          };
        };
        providers = {
          applications = {
            preferences = {
              defaultAction = "focus";
              launchPrefix = "uwsm app --";
              paths = [ ];
            };
          };
          "@knoopx/${inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}.firefox.name}" = {
            preferences = {
              profile_dir = "${config.programs.firefox.configPath}";
            };
          };
          core = {
            entrypoints = {
              oauth-token-store = {
                alias = "oauth";
                enabled = true;
              };
            };
          };
        };
        launcher_window = {
          opacity = 0.78;
          client_side_decorations = {
            enabled = true;
            border_width = 0;
          };
          floating_status_bar = true;
        };
      };
    };

  };
}

{
  flake.aspects."desktop.launcher.vicinae".homeManager =
    {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }:
    let
      extensions = config.profiles.vicinae.extensions;
      firefoxEnabled = config.programs.firefox.enable;
      defaultFont = config.profiles.fonts.default or "Monaco Nerd Font";
    in
    {

      options.profiles.vicinae = {
        extensions = lib.mkOption {
          type = lib.types.attrsOf lib.types.package;
          default = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
          readOnly = true;
        };
      };

      config = {

        programs.vicinae = {
          enable = true;
          systemd = {
            enable = true;
            autoStart = true;
          };
          mutableSettings = true;
          extensions = [ extensions.bitwarden ] ++ lib.optionals firefoxEnabled [ extensions.firefox ];
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
            input_server = {
              enabled = true;
            };
            tray = {
              enabled = true;
            };
            font = {
              rendering = "native";
              normal = {
                size = 12;
                family = defaultFont;
              };
            };
            theme = {
              light = {
                name = "noctalia";
                icon_theme = "Adwaita";
              };
              dark = {
                name = "noctalia";
                icon_theme = "Adwaita";
              };
            };
            providers = {
              applications = {
                preferences = {
                  defaultAction = "focus";
                  paths = [ ];
                };
              };
              "@bl4zee1g/${extensions.bitwarden.name}" = {
                preferences = {
                  rbwPath = "rbw";
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
              clipboard = {
                entrypoints = {
                  history = {
                    shortcut = "";
                  };
                };
              };
            }
            // lib.optionalAttrs firefoxEnabled {
              "@knoopx/${extensions.firefox.name}" = {
                preferences = {
                  profile_dir = config.programs.firefox.configPath or "${config.xdg.configHome}/mozilla/firefox";
                };
              };
            };
            launcher_window = {
              opacity = 0.78;
              client_side_decorations = {
                enabled = true;
                rounding = 10;
                border_width = 0;
                shadow_size = 10;
              };
              layer_shell.enabled = true;
              floating_status_bar = true;
            };
          };
        };
      };
    };

  flake.aspects.preservation.nixos =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.vicinae.enable
          [
            ".local/state/vicinae"
            ".local/share/vicinae"
          ];
    };

}

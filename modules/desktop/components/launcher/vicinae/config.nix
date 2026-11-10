{ inputs, ... }:
let
in
{
  flake.modules.homeManager."desktop.launcher.vicinae" = { pkgs, config, ... }: {

    programs.vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        nix
        github
        bitwarden
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
            family = "${config.profiles.fonts.default}";
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
          "@knoopx/${inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}.firefox.name}" = {
            preferences = {
              profile_dir = "${config.programs.firefox.configPath}";
            };
          };
          "@bl4zee1g/store.vicinae.bitwarden" = {
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

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (config.home-manager.users.${username}.programs.vicinae.enable)
          [
            ".local/state/vicinae"
            ".local/share/vicinae"
          ];
    };

  flake.modules.homeManager."desktop.hyprland" = {

    wayland.windowManager.hyprland = {
      extraConfig = ''
        hl.layer_rule {
        	name = "vicinae",
        	match = {
        		namespace = "vicinae",
        	},
        	blur = true,
        	ignore_alpha = 0,
        }

      '';
    };
  };

  flake.modules.homeManager."desktop.gnome" = { pkgs, ... }: {
    programs = {
      gnome-shell = {
        extensions = [
          { package = pkgs.gnomeExtensions.vicinae; }
        ];
      };
    };
  };

}

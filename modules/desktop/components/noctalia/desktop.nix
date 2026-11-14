{
  flake.modules.nixos._preservation-noctalia = { lib, config, username, ... }: {
    profiles.preservation.users.${username}.directories =
      lib.optionals config.home-manager.users.${username}.programs.noctalia.enable [ ".cache/noctalia" ".local/state/noctalia" ];
  };

  flake.modules.nixos."desktop.hyprland" = { self, ... }: {
    imports = [ self.modules.nixos._preservation-noctalia ];
  };

  flake.modules.nixos."desktop.niri" = { self, ... }: {
    imports = [ self.modules.nixos._preservation-noctalia ];
  };

  flake.modules.homeManager."desktop.hyprland" = {
    programs.noctalia = {
      settings = {
        theme = {
          templates = {
            builtin_ids = [
              "hyprland"
            ];
          };
        };
      };
    };
  };

  flake.modules.homeManager."desktop.niri" = { mylib, ... }: {
    programs.noctalia = mylib.mkForceRecursive {
      settings = {
        bar = {
          widgets = {
            radius = 0;
          };
        };
        theme = {
          templates = {
            builtin_ids = [
              "niri"
            ];
          };
        };
        shell = {
          niri_overview_close_on_launch_enabled = true;
          niri_overview_type_to_launch_enabled = true;
          settings_window_translucent = true;
        };
      };
    };

    wayland.windowManager.niri.settings = {

      binds =
        let
          allow-inhibiting = false;

          noctalia = args: {
            _props.allow-inhibiting = allow-inhibiting;
            spawn = [
              "noctalia"
              "msg"
            ]
            ++ args;
          };
        in
        {
          "Mod+Comma" = noctalia [
            "settings-toggle"
          ];
          "XF86AudioRaiseVolume" = noctalia [
            "volume-up"
          ];
          "XF86AudioLowerVolume" = noctalia [
            "volume-down"
          ];
          "XF86AudioMute" = noctalia [
            "volume-mute"
          ];
          "XF86AudioPlay" = noctalia [
            "media"
            "playPause"
          ];
          "XF86AudioNext" = noctalia [
            "media"
            "next"
          ];
          "XF86AudioPrev" = noctalia [
            "media"
            "previous"
          ];
          "XF86MonBrightnessUp" = noctalia [
            "brightness-up"
          ];
          "XF86MonBrightnessDown" = noctalia [
            "brightness-down"
          ];
          "Mod+Ctrl+q" = noctalia [
            "session"
            "lock"
          ];
          # "Mod+Ctrl+a" = noctalia [
          #   "screenshot-region"
          # ];
        };
      overview.workspace-shadow.off = { };
      _children = [

        {
          include = {
            _props.optional = true;
            _args = [ "noctalia.kdl" ];
          };
        }

        # Noctalia wallpaper
        {
          layer-rule._children = [
            {
              match._props.namespace = "^noctalia-wallpaper*";
            }
            { place-within-backdrop = true; }
          ];
        }

        # Quickshell overview
        {
          layer-rule._children = [
            {
              match._props.namespace = "^quickshell-overview$";
            }
            { place-within-backdrop = true; }
          ];
        }

        # Noctalia notifications
        {
          layer-rule._children = [
            {
              match._props.namespace = "noctalia-notifications";
            }
            { block-out-from = "screencast"; }
          ];
        }
      ];
    };

  };
}

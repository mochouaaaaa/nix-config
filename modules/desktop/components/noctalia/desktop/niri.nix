{

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
        backdrop = {
          enabled = false;
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
      # You can also fine-tune the blur effect globally.
      blur = {
        passes = 2; # // more passes = stronger blur (default: 3)
        offset = 3.0; # // sample distance per pass (default: 3.0)
        noise = 0.03; # // grain overlay (default: 0.02)
        saturation = 1.0; # // color saturation boost (default: 1.5)
      };
      _children = [

        {
          include = {
            _props.optional = true;
            _args = [ "noctalia.kdl" ];
          };
        }

        {
          window-rule._children = [
            {
              match._props = {
                app-id = "dev.noctalia.Noctalia";
              };
            }
            { open-floating = true; }
          ];
        }

        {
          window-rule._children = [
            {
              background-effect = {
                blur = true;
                xray = false;
              };
            }
          ];
        }

        {
          layer-rule._children = [
            {
              match._props.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
            }
            {
              background-effect = {
                xray = false;
                #  blur =false
              };
            }
          ];
        }

        {
          layer-rule._children = [
            { match._props.namespace = "noctalia-window-switcher"; }
            {
              background-effect = {
                blur = true;
                xray = false;
              };
            }
          ];
        }

        # Noctalia wallpaper
        {
          layer-rule._children = [
            {
              match._props.namespace = "^noctalia-wallpaper";
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

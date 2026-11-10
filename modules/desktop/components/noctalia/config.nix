{

  flake.modules.homeManager."desktop.shell.noctalia" = { lib, ... }: {

    # services.cliphist.enable = lib.mkForce false;

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
        audio = {
          enable_overdrive = false;
          enable_sounds = false;
          notification_sound = "";
          sound_volume = 0.5;
          volume_change_sound = "";
        };
        widget = {
          clock = {
            font_family = "Maple Mono CN";
            font_weight = 200;
            format = "{:%-m月%-d日 周%a %H:%M}";
          };
          media = {
            hide_when_no_media = true;
          };
        };
        location = {
          address = "北京";
          auto_locate = false;
          custom_schedule = false;
          longitude = 39.9042;
          sunrise = "";
          sunset = "";
        };
        bar = {
          order = [ "widgets" ];

          widgets = {
            concave_edge_corners = false;
            font_family = "Maple Mono CN";
            font_weight = 400;
            margin_ends = 0;
            padding = 30;
            panel_overlap = 0;
            radius = 18;
            radius_top_left = 0;
            radius_top_right = 0;
            scale = 1.1500000096857548;
            shadow = false;

            start = [ "workspaces" ];
            widget_spacing = 16;
            center = [ "media" ];
            end = [
              "tray"
              "notifications"
              "network"
              "bluetooth"
              "control-center"
              "clock"
              "session"
            ];

          };

        };

      };
    };

  };

  flake.modules.nixos._preservation-noctalia = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".cache/noctalia"
      ".local/state/noctalia"
    ];
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

  flake.modules.homeManager."desktop.niri" = {
    programs.noctalia = {
      settings = {
        theme = {
          templates = {
            builtin_ids = [
              "niri"
            ];
          };
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
              "noctalia-shell"
              "ipc"
              "call"
            ]
            ++ args;
          };
        in
        {
          "Mod+Comma" = noctalia [
            "settings"
            "toggle"
          ];

          "XF86AudioRaiseVolume" = noctalia [
            "volume"
            "increase"
          ];

          "XF86AudioLowerVolume" = noctalia [
            "volume"
            "decrease"
          ];

          "XF86AudioMute" = noctalia [
            "volume"
            "muteOutput"
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
            "brightness"
            "increase"
          ];

          "XF86MonBrightnessDown" = noctalia [
            "brightness"
            "decrease"
          ];

          "Mod+Ctrl+q" = noctalia [
            "lockScreen"
            "lock"
          ];
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

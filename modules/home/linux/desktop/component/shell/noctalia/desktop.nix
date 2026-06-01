{
  lib,
  config,
  ...
}:
with lib;
let
  cfgDesktop = config.profiles.desktop;
  cfgNoctalia = config.programs.noctalia-shell;
in
{
  config = mkIf (cfgNoctalia.enable) (mkMerge [
    {
      services.blueman-applet.enable = lib.mkForce false;
      services.network-manager-applet.enable = lib.mkForce false;
    }

    # hyprland
    (mkIf (cfgDesktop.hyprland.enable) {

      services.vicinae.enable = true;

      programs.noctalia-shell = {
        settings = lib.mkForceRecursive rec {
          ui = {
            panelBackgroundOpacity = 0.62;
          };
          appLauncher = {
            backgroundOpacity = ui.panelBackgroundOpacity;
            customLaunchPrefix = "hyprctl dispatch exec ";
          };
          bar = {
            backgroundOpacity = ui.panelBackgroundOpacity;
          };
          notifications = {
            backgroundOpacity = ui.panelBackgroundOpacity;
          };
          osd = {
            backgroundOpacity = ui.panelBackgroundOpacity;
          };

          sessionMenu = {
          };

        };
      };

      wayland.windowManager.hyprland = {
        extraConfig = ''
          _G.windowOpacity = 0.88

          hl.config{
            decoration = {
                rounding = 14,
                blur = {
                ignore_opacity = false,
                passes = 4,
                size = 2,
                vibrancy = 0.28,
                vibrancy_darkness = 0.14,
                },
            }
          }

          hl.layer_rule {
            name = "noctalia",
            match = {
                namespace = "noctalia-.*"
            },
            ignore_alpha = 0,
            blur = true
          }

          -- noctalia
          hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia-shell ipc call media playPause"))
          hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia-shell ipc call media next"))
          hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia-shell ipc call media previous"))
          hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput"))

          hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase"))
          hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease"))
          hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("noctalia-shell ipc call volume increase"))
          hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease"))

          hl.bind("SUPER+CTRL+Q", hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))
        '';
      };

    })

    (mkIf (cfgDesktop.niri.enable) {

      services.vicinae.enable = true;
      programs.noctalia-shell = {
        settings = lib.mkForceRecursive rec {
          ui = {
            panelBackgroundOpacity = 0.62;
          };
          appLauncher = {
            backgroundOpacity = ui.panelBackgroundOpacity;
          };
          bar = {
            backgroundOpacity = ui.panelBackgroundOpacity;
          };
          notifications = {
            backgroundOpacity = ui.panelBackgroundOpacity;
          };
          osd = {
            backgroundOpacity = ui.panelBackgroundOpacity;
          };
          general = {
            showScreenCorners = false;
          };
          bar = {
            outerCorners = false;
          };
          wallpaper = {
            overviewBlur = 0.4;
            overviewTint = 0;
          };
        };
      };

      programs.niri.settings = {
        includes = [
          "noctalia.kdl"
        ];
        binds =
          let
            allow-inhibiting = false;
          in
          with config.lib.niri.actions;
          {
            # "Mod+Space".action = spawn "noctalia-shell" "ipc" "call" "launcher" "toggle";
            "Mod+Comma" = {
              inherit allow-inhibiting;
              action = spawn "noctalia-shell" "ipc" "call" "settings" "toggle";
            };

            "XF86AudioRaiseVolume" = {
              inherit allow-inhibiting;
              action = spawn "noctalia-shell" "ipc" "call" "volume" "increase";
            };
            "XF86AudioLowerVolume" = {
              inherit allow-inhibiting;
              action = spawn "noctalia-shell" "ipc" "call" "volume" "decrease";
            };
            "XF86AudioMute" = {
              inherit allow-inhibiting;
              action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput");
            };
            "XF86AudioPlay" = {
              inherit allow-inhibiting;
              action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "playPause");
            };
            "XF86AudioNext" = {
              inherit allow-inhibiting;
              action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "next");
            };
            "XF86AudioPrev" = {
              inherit allow-inhibiting;
              action = lib.mkForce (spawn "noctalia-shell" "ipc" "call" "media" "previous");
            };

            # F2
            "XF86MonBrightnessUp" = {
              inherit allow-inhibiting;
              action = spawn "noctalia-shell" "ipc" "call" "brightness" "increase";
            };
            # F1
            "XF86MonBrightnessDown" = {
              inherit allow-inhibiting;
              action = spawn "noctalia-shell" "ipc" "call" "brightness" "decrease";
            };

            # "Mod+P".action = spawn "noctalia-shell" "ipc" "call" "launcher" "clipboard";
            "Mod+Ctrl+q" = {
              inherit allow-inhibiting;
              action = spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock";
            };
          };
        overview.workspace-shadow = {
          enable = false;
        };
        layer-rules = [
          {
            matches = [
              {
                namespace = "^noctalia-wallpaper*";
              }
            ];
            place-within-backdrop = true;
          }
          {
            matches = [
              {
                namespace = "^quickshell-overview$";
              }
            ];
            place-within-backdrop = true;
          }
          {
            matches = [
              {
                namespace = "noctalia-notifications";
              }
            ];
            block-out-from = "screencast";
          }
        ];
      };

    })

  ]);
}

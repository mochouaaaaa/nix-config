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

      services.darkman = {
        lightModeScripts = {
          light = ''
            noctalia-shell ipc call darkMode setLight
          '';
        };
        darkModeScripts = {
          dark = ''
            noctalia-shell ipc call darkMode setDark
          '';
        };
      };
    }

    # hyprland
    (mkIf (cfgDesktop.hyprland.enable) {

      services.vicinae.enable = true;

      programs.noctalia-shell = {
        settings = rec {
          templates.hyprland = lib.mkForce true;
          ui = {
            # panelBackgroundOpacity = lib.mkForce 0.44;
            panelBackgroundOpacity = lib.mkForce 0.62;
          };
          appLauncher = {
            backgroundOpacity = ui.panelBackgroundOpacity;
            customLaunchPrefix = lib.mkForce "hyprctl dispatch exec ";
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
            powerOptions = [
              {
                action = "reboot";
                command = ''hyprshutdown -p "reboot"'';
                enabled = true;
              }
              {
                action = "logout";
                command = "hyprshutdown";
                enabled = true;
              }
              {
                action = "shutdown";
                command = ''hyprshutdown -p "poweroff"'';
                enabled = true;
              }
            ];
          };

        };
      };

      wayland.windowManager.hyprland = {
        extraConfig = lib.mkOrder 2000 ''
          source = noctalia/noctalia-colors.conf
        '';
        settings = {
          "$windowOpacity" = lib.mkForce 0.88;
          decoration = lib.mkForceRecursive {
            rounding = 14;
            blur = {
              ignore_opacity = false;
              passes = 4;
              size = 2;
              vibrancy = 0.28;
              vibrancy_darkness = 0.14;
            };
          };
          layerrule = [
            "blur on, match:namespace noctalia-.*"
            "ignore_alpha 0, match:namespace noctalia-.*"
          ];
        };
      };

      profiles.desktop.hypridle.lock_cmd = "noctalia-shell ipc call lockScreen lock";

      profiles.desktop.hyprland = {
        settings = {
          media = [
            ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
            ", XF86AudioNext, exec, noctalia-shell ipc call media next"
            ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
            ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
          ];
          brightness = [
            ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase" # f2
            ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease" # f1
          ];
          volume = [
            ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase" # f12
            ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease" # f11
          ];
          lock = "$mod CTRL, q, exec, noctalia-shell ipc call lockScreen lock";
          shell-settings = "$mod, comma, exec, noctalia-shell ipc call settings toggle";
        };
      };

    })

    (mkIf (cfgDesktop.niri.enable) {

      services.vicinae.enable = true;
      programs.noctalia-shell.settings = {
        general = {
          showScreenCorners = false;
        };
        templates = {
          niri = lib.mkForce true;
        };
        bar = {
          outerCorners = false;
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
        layout.background-color = "transparent";
        overview.workspace-shadow = {
          enable = true;
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

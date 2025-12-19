{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfgDesktop = config.modules'.desktop;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{
  config = mkIf (cfgNoctalia.enable) (mkMerge [

    # hyprland
    (mkIf (cfgDesktop.hyprland.enable) {

      modules'.desktop.shell.noctalia = {
        settings = rec {
          ui = {
            panelBackgroundOpacity = lib.mkForce 0.44;
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
        };
      };

      wayland.windowManager.hyprland = {
        settings = {
          decoration = lib.mkForceRecursive {
            rounding = 15;
          };
          layerrule = [
            "blur, noctalia-.*"
            "ignorezero, noctalia-.*"
          ];
        };
      };

      modules'.desktop.hypridle.lock_cmd = "noctalia-shell ipc call lockScreen lock";

      modules'.desktop.hyprland = {
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

      programs.noctalia-shell.enable = true;

      modules'.desktop.shell.noctalia.settings = {
        general = {
          showScreenCorners = false;
        };
        templates = {
          niri = lib.mkForce true;
        };
      };

      programs.niri.settings = {
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
        layer-rules = [
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

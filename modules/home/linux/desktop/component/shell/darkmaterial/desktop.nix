{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.programs.dankMaterialShell;
  cfgDesktop = config.profiles.desktop;
in
{
  imports = [
    inputs.DankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  config = mkIf (cfg.enable) (
    lib.mkMerge [

      {
        services.darkman = {
          lightModeScripts = {
            light = ''
              dms ipc call theme light
            '';
          };
          darkModeScripts = {
            dark = ''
              dms ipc call theme dark
            '';
          };
        };
      }

      # hyprland
      (lib.mkIf (cfgDesktop.hyprland.enable) {
        services.vicinae.enable = true;

        profiles.desktop.hyprland = {
          settings = {
            media = [ ];
            brightness = [
              ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 5"
              ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5"
            ];
            volume = [
              ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
              ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
            ];
            # clipboard = "$mod, P, exec, dms ipc call clipboard toggle";
            # launcher = "$mod, Space, exec, dms ipc call spotlight toggle";
            lock = "$mod CTRL, q, exec, dms ipc call lock lock";
            shell-settings = "$mod, comma, exec, dms ipc call settings toggle";
          };
        };

        wayland.windowManager.hyprland = {
          settings = {
            decoration = lib.mkForceRecursive {
              shadow = {
                enabled = true;
                range = 30;
                render_power = 5;
                offset = "0 5";
                color = "rgba(00000070)";
              };
              blur = {
                enabled = true;
                size = 10;
                passes = 4;

                ignore_opacity = true;
                new_optimizations = true;
                xray = false;

                noise = 0.02;
                contrast = 1.1;
                vibrancy = 0.2;
                vibrancy_darkness = 0.3;
              };
              rounding = 12;
              active_opacity = 1.0;
              inactive_opacity = 0.9;
            };
            bindl = [
              ", XF86AudioMute, exec, dms ipc call audio mute"
              ", XF86AudioMicMute, exec, dms ipc call audio micmute"
            ];
            windowrule = [
              "float on, match:class org.quickshell"
            ];
            "$blur_layer" = "dms:(color-picker|clipboard|spotlight|settings)";
            layerrule = [
              "blur on, match:namespace dms:.*"
              "ignore_alpha 0, match:namespace dms:.*"

              "animation slide right, match:namespace dms:control-center"
              "animation slide top, match:namespace dms:workspace-overview"

              "no_anim on, match:namespace ^(quickshell)$"
            ];
          };
        };

      })

      (lib.mkIf (cfgDesktop.niri.enable) {

        services.vicinae.enable = true;

        programs.dankMaterialShell = {
          default.settings = lib.mkForce {
            dankBarGothCornersEnabled = false;
          };
        };

        programs.niri.settings = {
          binds =
            let
              allow-inhibiting = false;
            in
            with config.lib.niri.actions;
            {
              "Mod+Ctrl+q" = {
                inherit allow-inhibiting;
                action = spawn "dms" "ipc" "call" "lock" "lock";
              };
              "Mod+M" = {
                inherit allow-inhibiting;
                hotkey-overlay.title = "Task Manager";
                action.spawn = [
                  "dms"
                  "ipc"
                  "call"
                  "processlist"
                  "toggle"
                ];
              };
              "Mod+Comma" = {
                inherit allow-inhibiting;
                hotkey-overlay.title = "Settings";
                action.spawn = [
                  "dms"
                  "ipc"
                  "call"
                  "settings"
                  "toggle"
                ];
              };

              "XF86AudioMute" = {
                inherit allow-inhibiting;
                action = spawn "dms" "ipc" "call" "audio" "mute";
              };
              "XF86AudioMicMute" = {
                inherit allow-inhibiting;
                action = spawn "dms" "ipc" "call" "audio" "micmute";
              };
              "XF86AudioRaiseVolume" = {
                inherit allow-inhibiting;
                action = spawn "dms" "ipc" "call" "audio" "increment" "3";
              };
              "XF86AudioLowerVolume" = {
                inherit allow-inhibiting;
                action = spawn "dms" "ipc" "call" "audio" "decrement" "3";
              };
              "XF86MonBrightnessUp" = {
                inherit allow-inhibiting;
                action = spawn "dms" "ipc" "call" "brightness" "increment" "5" "";
              };
              "XF86MonBrightnessDown" = {
                inherit allow-inhibiting;
                action = spawn "dms" "ipc" "call" "brightness" "decrement" "5" "";
              };
            };
          window-rules = [
            {
              matches = [
                {
                  appid = "org.quickshell$";
                }
              ];
              open-floating = true;
            }
          ];
          layer-rules = [
            {
              matches = [
                {
                  namespace = "^quickshell$";
                }
              ];
              place-within-backdrop = true;
            }
            {
              matches = [
                {
                  namespace = "dms:blurwallpaper";
                }
              ];
              place-within-backdrop = true;
            }

          ];
        };

      })

    ]
  );
}

{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.programs.dank-material-shell;
  cfgDesktop = config.profiles.desktop;
in
{
  imports = [
    # inputs.dank-material-shell.homeModules.niri
  ];

  config = mkIf (cfg.enable) (
    lib.mkMerge [

      {
        services.darkman = {
          enable = lib.mkForce false;
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

        programs.dank-material-shell = {
          settings = {
            matugenTemplateHyprland = true;
            # barConfigs = [
            #   {
            #     gothCornerRadiusValue = 18;
            #     gothCornersEnabled = true;
            #   }
            # ];
          };
        };

        wayland.windowManager.hyprland = {
          extraConfig = ''
            hl.config({
                decoration = {
                    shadow = {
                        enabled = true,
                        range = 30,
                        render_power = 5,
                        offset = "0 5",
                        color = "rgba(00000070)",
                    };
                    blur = {
                        enabled = true,
                        size = 10,
                        passes = 4,

                        ignore_opacity = true,
                        new_optimizations = true,
                        xray = false,

                        noise = 0.02,
                        contrast = 1.1,
                        vibrancy = 0.2,
                        vibrancy_darkness = 0.3,
                    };
                    rounding = 12,
                    active_opacity = 1.0,
                    inactive_opacity = 0.9,
                },
            })

            hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("dms ipc call brightness increment 5"))
            hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("dms ipc call brightness decrement 5"))
            hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"))
            hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"))
            hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"))
            hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"))

            hl.bind("SUPER+P", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
            hl.bind("SUPER+Space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))

            hl.bind("SUPER+CTRL+Q", hl.dsp.exec_cmd("dms ipc call lock lock"))
            hl.bind("SUPER+comma", hl.dsp.exec_cmd("dms ipc call settings toggle"))

            hl.layer_rule{ match = {namespace = "dms:.*"}, blue = true }
            hl.layer_rule{ match = {namespace = "dms:.*"}, ignore_alpha = 0 }
            hl.layer_rule{ match = {namespace = "dms:control-center"}, animation = "slide right" }
            hl.layer_rule{ match = {namespace = "dms:workspace-overview"}, animation = "slide right" }
            hl.layer_rule{ match = {namespace = "^(quickshell)$"}, no_anim = true }

            hl.window_rule{ name = "quickshell", match = { class = "org.quickshell" }, float = true }
          '';
        };

      })

      (lib.mkIf (cfgDesktop.niri.enable) {

        services.vicinae.enable = true;

        programs.dank-material-shell = {
          settings = lib.mkForceRecursive {
            dankBarGothCornersEnabled = false;
            matugenTemplateNiri = true;
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
                  app-id = "org.quickshell$";
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

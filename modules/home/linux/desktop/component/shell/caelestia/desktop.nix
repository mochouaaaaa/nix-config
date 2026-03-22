{
  lib,
  config,
  ...
}:
let
  cfgDesktop = config.profiles.desktop;
  cfg = config.profiles.desktop.shell.caelestia;
in
{
  config = lib.mkIf (cfg.enable) (
    lib.mkMerge [

      {
        services.darkman = {
          lightModeScripts = {
            light = ''
              caelestia scheme set -n dynamic --mode light
            '';
          };
          darkModeScripts = {
            dark = ''
              caelestia scheme set -n dynamic --mode dark
            '';
          };
        };
      }

      (lib.mkIf cfgDesktop.hyprland.enable {

        profiles.desktop.hypridle.lock_cmd = "caelestia shell lock lock";

        profiles.desktop.hyprland = {
          settings = {
            media = [
              ", XF86AudioPlay, global, caelestia:mediaToggle"
              ", XF86AudioPause, global, caelestia:mediaToggle"
              ", XF86AudioNext, global, caelestia:mediaNext"
              ", XF86AudioPrev, global, caelestia:mediaPrev"
              ", XF86AudioStop, global, caelestia:mediaStop"
            ];
            brightness = [
              ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
              ", XF86MonBrightnessDown, global, caelestia:brightnessDown"
            ];
            clipboard = "$mod, P, exec, caelestia clipboard";
            launcher = "$mod, Space, global, caelestia:launcher";
            lock = "$mod CTRL, q, global, caelestia:lock";
            screenshot = [
              "$mod CTRL, S, exec, caelestia screenshot -r -f"
              "$mod CTRL, A, exec, caelestia screenshot --region -f"
            ];
          };
        };
        wayland.windowManager.hyprland = {
          settings = {
            exec = "cp -L --no-preserve=mode --update=none ${config.xdg.configHome}/hypr/scheme/default.conf ${config.xdg.configHome}/hypr/scheme/current.conf";
            "$windowOpacity" = lib.mkForce 0.78;
            source = [
              "scheme/current.conf"
              "variables.conf"
            ];
            bind = [
              "$mod, comma, exec, caelestia shell controlCenter open"
            ];

            input = lib.mkForceRecursive {
              touchpad = {
                disable_while_typing = "$touchpadDisableTyping";
                scroll_factor = "$touchpadScrollFactor";
              };
            };

            misc = lib.mkForceRecursive {
              background_color = "rgb($surfaceContainer)";
            };

            general = lib.mkForceRecursive {
              layout = "dwindle";
              border_size = "$windowBorderSize";

              gaps_workspaces = "$workspaceGaps";
              gaps_in = "$windowGapsIn";
              gaps_out = "$windowGapsOut";
              "col.active_border" = "$activeWindowBorderColour";
              "col.inactive_border" = "$inactiveWindowBorderColour";
            };

            decoration = lib.mkForceRecursive {
              rounding = "$windowRounding";
              blur = {
                passes = 3;
                size = 4;
              };
              shadow = {
                enabled = "$shadowEnabled";
                range = "$shadowRange";
                render_power = "$shadowRenderPower";
                color = "$shadowColour";
              };
            };

            group = lib.mkForceRecursive {

              "col.border_active" = "$activeWindowBorderColour";
              "col.border_inactive" = "$inactiveWindowBorderColour";
              "col.border_locked_active" = "$activeWindowBorderColour";
              "col.border_locked_inactive" = "$inactiveWindowBorderColour";

              groupbar = {
                text_color = "rgb($onPrimary)";
                "col.active" = "rgba($primaryd4)";
                "col.inactive" = "rgba($outlined4)";
                "col.locked_active" = "rgba($primaryd4)";
                "col.locked_inactive" = "rgba($secondaryd4)";
              };
            };

            windowrule = [
              # "opacity $windowOpacity override, match:fullscreen  "
              "opaque on, match:class org\.quickshell" # They use native transparency or we want them opaque
              "float on, match:class org\.quickshell"
            ];

            layerrule = [
              # Shell
              "no_anim on, match:namespace caelestia-(border-exclusion|area-picker)"
              "animation fade, match:namespace caelestia-(drawers|background)"

              "blur on, match:namespace caelestia-drawers"
              "blur on, match:namespace launcher"
              "ignore_alpha 0.57, match:namespace caelestia-drawers"
            ];

          };
        };

        xdg.configFile = {
          "hypr/variables.conf" = {
            text = ''
              # ### Hyprland ###
              # Apps

              # Touchpad
              $touchpadDisableTyping = true
              $touchpadScrollFactor = 0.2
              $workSpaceSwipeFingers = 4

              # Blur
              $blurEnabled = true
              $blurSpecialWs = false
              $blurPopups = true
              $blurInputMethods = true
              $blurSize = 8
              $blurPasses = 4
              $blurXray = false

              # Shadow
              $shadowEnabled = true
              $shadowRange = 20
              $shadowRenderPower = 3
              $shadowColour = rgba($surfaced4)

              # Gaps
              $workspaceGaps = 20
              $windowGapsIn = 3
              $windowGapsOut = 6
              $singleWindowGapsOut = 20

              # Window styling
              $windowOpacity = 0.85
              $windowRounding = 10

              $windowBorderSize = 3
              $activeWindowBorderColour = rgba($primarye6)
              $inactiveWindowBorderColour = rgba($onSurfaceVariant11)

            '';
          };
        };

      })

    ]
  );

}

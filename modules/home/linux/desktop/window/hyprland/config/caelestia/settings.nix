{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.caelestia;
  cfgLauncher = config.modules'.desktop.services.vicinae;
in
{

  config = lib.mkIf cfg.enable {

    modules'.desktop.services.vicinae.enable = lib.mkForce false;

    wayland.windowManager.hyprland = {
      settings = {
        exec = "cp =: ==no-preserve=mode --update=none ${config.xdg.configHome}/hypr/scheme/default.conf ${config.xdg.configHome}/hypr/scheme/current.conf";

        source = [
          "${config.xdg.configHome}/hypr/scheme/current.conf"
          "${config.xdg.configHome}/hypr/variables.conf"
        ];

        bind = [
          "$mod CTRL, q, global, caelestia:lock"
          "$mod CTRL, S, exec, caelestia screenshot -r -f"
          "$mod CTRL, A, exec, caelestia screenshot --region -f"
        ]
        ++ lib.optionals (!cfgLauncher.enable) [
          "$mod, Space,global, caelestia:launcher"
          "$mod, P, exec, caelestia clipboard"
        ];
        bindl = [
          ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
          ", XF86MonBrightnessDown, global, caelestia:brightnessDown"

          ", XF86AudioPlay, global, caelestia:mediaToggle"
          ", XF86AudioPause, global, caelestia:mediaToggle"
          ", XF86AudioNext, global, caelestia:mediaNext"
          ", XF86AudioPrev, global, caelestia:mediaPrev"
          ", XF86AudioStop, global, caelestia:mediaStop"
        ];

        input = {
          touchpad = {
            disable_while_typing = lib.mkForce "$touchpadDisableTyping";
            scroll_factor = lib.mkForce "$touchpadScrollFactor";
          };
        };

        misc = {
          background_color = lib.mkForce "rgb($surfaceContainer)";
        };

        general = {
          border_size = lib.mkForce "$windowBorderSize";

          gaps_workspaces = lib.mkForce "$workspaceGaps";
          gaps_in = lib.mkForce "$windowGapsIn";
          gaps_out = lib.mkForce "$windowGapsOut";
          "col.active_border" = lib.mkForce "$activeWindowBorderColour";
          "col.inactive_border" = lib.mkForce "$inactiveWindowBorderColour";
        };

        decoration = {
          rounding = lib.mkForce "$windowRounding";
          shadow = {
            enabled = lib.mkForce "$shadowEnabled";
            range = lib.mkForce "$shadowRange";
            render_power = lib.mkForce "$shadowRenderPower";
            color = lib.mkForce "$shadowColour";
          };
        };

        group = {

          "col.border_active" = lib.mkForce "$activeWindowBorderColour";
          "col.border_inactive" = lib.mkForce "$inactiveWindowBorderColour";
          "col.border_locked_active" = lib.mkForce "$activeWindowBorderColour";
          "col.border_locked_inactive" = lib.mkForce "$inactiveWindowBorderColour";

          groupbar = {
            text_color = lib.mkForce "rgb($onPrimary)";
            "col.active" = lib.mkForce "rgba($primaryd4)";
            "col.inactive" = lib.mkForce "rgba($outlined4)";
            "col.locked_active" = lib.mkForce "rgba($primaryd4)";
            "col.locked_inactive" = lib.mkForce "rgba($secondaryd4)";
          };
        };

        workspace = [
          "w[tv1]s[false], gapsout:$singleWindowGapsOut"
          "f[1]s[false], gapsout:$singleWindowGapsOut"
        ];

        windowrule = [
          "opaque, class:org\.quickshell" # They use native transparency or we want them opaque
          "float, class:org\.quickshell"
        ];

        layerrule = [
          # Shell
          "noanim, caelestia-(border-exclusion|area-picker)"
          "animation fade, caelestia-(drawers|background)"

          "blur, caelestia-drawers"
          "ignorealpha 0.57, caelestia-drawers"
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
          $blurPasses = 2
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

  };

}

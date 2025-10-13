{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.shell.caelestia;
in
{

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        source = [
          "${config.xdg.configHome}/hypr/scheme/current.conf"
          "${config.xdg.configHome}/hypr/variables.conf"
        ];

        inputs = {
          touchpad = {
            disable_while_typing = "$touchpadDisableTyping";
            scroll_factor = "$touchpadScrollFactor";
          };
        };

        misc = {
          background_color = "rgb($surfaceContainer)";
        };

        general = {
          border_size = "$windowBorderSize";

          gaps_workspaces = "$workspaceGaps";
          gaps_in = "$windowGapsIn";
          gaps_out = "$windowGapsOut";
          "col.active_border" = "$activeWindowBorderColour";
          "col.inactive_border" = "$inactiveWindowBorderColour";
        };

        decoration = {
          rounding = "$windowRounding";
          shadow = {
            enabled = "$shadowEnabled";
            range = "$shadowRange";
            render_power = "$shadowRenderPower";
            color = "$shadowColour";
          };
        };

        group = {

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

        workspace = [
          "w[tv1]s[false], gapsout:$singleWindowGapsOut"
          "f[1]s[false], gapsout:$singleWindowGapsOut"
        ];

        windowrule = [
          "opaque, class:org\.quickshell" # They use native transparency or we want them opaque
          "float, class:org\.quickshell"
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

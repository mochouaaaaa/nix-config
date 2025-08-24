{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        exec = "cp =: ==no-preserve=mode --update=none ${config.xdg.configHome}/hypr/scheme/default.conf ${config.xdg.configHome}/hypr/scheme/current.conf";
        source = [
          "${config.xdg.configHome}/hypr/scheme/current.conf"
          "${config.xdg.configHome}/hypr/variables.conf"
        ];

        #opengl {
        #  nvidia_anti_flicker = true
        #}

        #could help when scaling and not pixelating
        xwayland = {
          # force_zero_scaling = true;
        };

        # render section for hyprland >= v0.42.0
        render = {
          cm_auto_hdr = 1; # 0.50
          # explicit_sync = 0
          # explicit_sync_kms = 2
          # direct_scanout = false
        };

        # cursor = {
        #   no_hardware_cursors = true;
        #   enable_hyprcursor = true;
        #   warp_on_change_workspace = true;
        #   no_warps = true;
        # };

        # ecosystem = {
        #   no_donation_nag = true;
        #   # enforce_permissions = true
        # };

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

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

  };
}

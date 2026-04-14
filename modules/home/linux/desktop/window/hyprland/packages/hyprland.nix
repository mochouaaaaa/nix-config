{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{

  config = lib.mkIf cfg.enable {

    nix.settings = {
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    wayland.systemd.target = "hyprland-session.target";

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
        enableXdgAutostart = true;
      };
      extraConfig = lib.mkBefore ''
                  
        xwayland {
          force_zero_scaling = true
        }

      '';
    };

    home.pointerCursor = {
      hyprcursor = {
        enable = true;
      };
    };

  };
}

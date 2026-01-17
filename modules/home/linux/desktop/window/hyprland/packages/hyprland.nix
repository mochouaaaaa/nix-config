{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{

  imports = [ inputs.hyprland.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {

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

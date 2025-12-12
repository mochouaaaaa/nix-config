{
  pkgs,
  config,
  lib,
  inputs,
  isNixos,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    wayland.windowManager.hyprland = {
      enable = true;
      package =
        if isNixos then null else inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        if isNixos then
          null
        else
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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

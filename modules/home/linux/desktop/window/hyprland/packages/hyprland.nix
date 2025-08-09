{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable rec {

    wayland.windowManager.hyprland = {
      enable = true;
      #  package =pkgs.hyprland;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
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

    home.file.".wayland-session" = {
      # source = "${wayland.windowManager.hyprland.package}/bin/Hyprland";
      text = ''
        ${lib.getExe pkgs.bash} -e
        unset LD_LIBRARY_PATH
         exec -a "$0" ${wayland.windowManager.hyprland.package}/bin/Hyprland "$@"
      '';
      executable = true;
    };
  };
}

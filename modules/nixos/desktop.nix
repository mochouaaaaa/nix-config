{
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
with lib; let
  cfgWayland = config.modules.desktop.wayland;
in {
  imports = [
    ../base.nix
    ./base

    ./desktop
  ];

  options.modules.desktop = {
    wayland = {enable = mkEnableOption "Wayland Display Server";};
  };

  config = mkMerge [
    (mkIf cfgWayland.enable {
      ####################################################################
      #  NixOS's Configuration for Wayland based Window Manager
      ####################################################################
      xdg.portal = {
        enable = true;
        wlr.enable = true;
      };

      services = {
        xserver.enable = false; # disable xorg server
        # https://wiki.archlinux.org/title/Greetd
        greetd = let
          session = {
            user = myvars.username;
            command = "${lib.getExe config.programs.hyprland.package}";
            # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session"; # start wayland session with a TUI login manager
          };
        in {
          enable = true;
          settings = {
            terminal.vt = 1;
            default_session = session;
            initial_session = session;
          };
        };
      };
    })
  ];
}

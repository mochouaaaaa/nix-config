{
  pkgs,
  pkgs-stable,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # package = pkgs-stable.hyprland;
    xwayland.enable = true;
    # plugins = with pkgs; [
    # hyprlandPlugins.borders-plus-plus
    # hyprlandPlugins.hyprbars
    # hyprlandPlugins.hyprexpo
    # hyprlandPlugins.hyprtrails
    # hyprlandPlugins.hyprwinwrap
    # ];
    systemd = {
      enable = true;
      variables = ["--all"];
      extraCommands = ["systemctl --user start hyprland-session.target"];
    };
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
    settings = {
      env = [
        "NIXOS_OZONE_WL,1"
        "PATH,$PATH:$HOME/.config/hypr/bin"
      ];
      exec-once = [
        "${pkgs.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator"
        "${pkgs.clash-verge-rev}/bin/clash-verge-service &"
        "${lib.getExe pkgs.clash-verge-rev} &"
        "${lib.getExe pkgs.pot} &"
      ];
    };
  };

  xdg.configFile = {
    "hypr" = {
      source = ./hypr;
      recursive = true;
      force = true;
    };
  };

  services.hypridle = {
    enable = true;
  };
}

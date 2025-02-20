{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = with pkgs; [
      hyprlandPlugins.borders-plus-plus
      hyprlandPlugins.hyprbars
      hyprlandPlugins.hyprexpo
      hyprlandPlugins.hyprtrails
      hyprlandPlugins.hyprwinwrap
    ];
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    # extraConfig = baseFile;
    settings = {
      env = [
        "NIXOS_OZONE_WL=1"
        "PATH,$PATH:$HOME/.config/hypr/bin"
      ];
      exec-once = [
        "systemctl --user start hyprland-session.target"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator"
        "clash-verge-service &"
        "${lib.getExe pkgs.clash-verge-rev} &"
        "pot &"
      ];
    };
  };

  xdg.configFile = {
    "hypr" = {
      source = ../hypr;
      recursive = true;
      force = true;
    };
  };

  services.hypridle = {
    enable = true;
  };
}

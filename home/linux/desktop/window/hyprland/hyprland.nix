{
  pkgs,
  pkgs-stable,
  config,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # package = pkgs-stable.hyprland;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
      extraCommands = ["systemctl --user start hyprland-session.target"];
    };
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
      source = config.lib.file.mkOutOfStoreSymlink ./hypr;
      force = true;
    };
    "hypr/hyprland.conf".enable = false;
  };

  services.hypridle = {
    enable = true;
  };
}

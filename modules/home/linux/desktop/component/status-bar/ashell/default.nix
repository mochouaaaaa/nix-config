{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.component.status-bar.ashell;
in
{

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      libappindicator-gtk3
    ];

    programs.ashell = {
      enable = true;
      package = pkgs.ashell;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };
  };
}

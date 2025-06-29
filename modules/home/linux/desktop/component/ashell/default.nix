{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.component.ashell;
in
{

  options.modules.desktop.component.ashell = {
    enable = lib.mkEnableOption "Ashell" // {
      default = false;
    };
  };

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

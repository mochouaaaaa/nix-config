{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfgNiri = config.profiles.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

    programs.gtklock = {
      enable = true;
      config = {
        main = {
          idle-hide = true;
          idle-timeout = 60;
        };
      };
      modules = with pkgs; [
        gtklock-playerctl-module
        gtklock-powerbar-module
        gtklock-userinfo-module
      ];
    };

  };
}

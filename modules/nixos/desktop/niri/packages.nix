{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfgNiri = config.modules.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

    environment.systemPackages = with pkgs; [
      cage

      turtle # nautilus plugin
      nautilus
    ];

    programs = {
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

  };
}

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

      turtle # nautilus plugin
      nautilus
    ];

    programs = {
      ssh.startAgent = lib.mkForce false;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

  };
}

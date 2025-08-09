{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.niri;
in
{

  config = lib.mkIf cfg.enable {

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

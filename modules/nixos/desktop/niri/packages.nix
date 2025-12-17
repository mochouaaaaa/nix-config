{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfgNiri = config.modules'.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

    programs = {
      ssh.startAgent = lib.mkForce false;
    };

  };
}

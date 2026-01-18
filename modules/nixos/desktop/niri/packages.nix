{
  config,
  lib,
  ...
}:
let
  cfgNiri = config.profiles.desktop.niri;
in
{

  config = lib.mkIf cfgNiri.enable {

  };
}

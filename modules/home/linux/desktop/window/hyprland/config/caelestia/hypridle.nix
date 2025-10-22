{
  lib,
  config,
  ...
}:
let
  cfg = config.modules'.desktop.shell.caelestia;
in
{
  config = lib.mkIf cfg.enable {

    modules'.desktop.hypridle.lock_cmd = "caelestia shell lock lock";

  };

}

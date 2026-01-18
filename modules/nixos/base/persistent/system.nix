{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.persistent;
in
{

  config = lib.mkIf cfg.enable {
    # system.etc.overlay.enable = false;
  };
}

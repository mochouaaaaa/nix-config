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
    system.etc.overlay.enable = true;
    system.nixos-init.enable = config.system.etc.overlay.enable;
  };
}

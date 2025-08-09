{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.dm.gdm;
in
{
  options.modules.dm.gdm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable gdm.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
        autoLogin.delay = 0;
      };
    };
  };
}

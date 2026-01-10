{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    qt = {
      # ERROR: It will cause the core to collapse
      enable = lib.mkForce false;
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
let

  cfg = config.modules'.desktop.hyprland.caelestia;

  img = pkgs.fetchurl {
    url = "***REMOVED***";
    hash = "sha256-VN4MBUSovo5YxOIvcbWjAP2O0R0Vt4fK0C5723cGtIQ=";
  };
in
{

  config = lib.mkIf cfg.enable {
    home.file.".face".source = img;
  };

}

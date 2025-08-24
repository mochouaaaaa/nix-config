{
  pkgs,
  lib,
  config,
  ...
}:
let
  img = pkgs.fetchurl {
    url = "***REMOVED***";
    hash = "sha256-VN4MBUSovo5YxOIvcbWjAP2O0R0Vt4fK0C5723cGtIQ=";
  };
in
{

  options.modules'.desktop = {
    face = lib.mkOption {
      type = lib.types.path;
      default = img;
      description = "Path to the face image to be displayed in the login screen.";
    };
  };

  config = {
    home.file = {
      ".face".source = config.modules'.desktop.face;
    };
  };

}

{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    services = {
      flatpak = {
        packages = [ "org.gnome.Extensions" ];
      };
    };

  };
}

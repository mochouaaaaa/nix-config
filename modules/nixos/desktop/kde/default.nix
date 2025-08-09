{
  lib,
  config,
  ...
}:
let
  cfgKde = config.modules'.desktop.kde;
in
{

  imports = lib.importModule' ./.;

  config = lib.mkIf cfgKde.enable {

    services = {
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };
      desktopManager = {
        plasma6.enable = true;
      };
    };

    programs.xwayland.enable = true;
    i18n.inputMethod.fcitx5.plasma6Support = true;
  };
}

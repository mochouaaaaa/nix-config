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

    security.pam.services = {
      login.kwallet.enable = lib.mkForce false;
      sddm.enableGnomeKeyring = true;
      sddm-greeter.enableGnomeKeyring = true;
      sddm-autologin.enableGnomeKeyring = true;
      kde = {
        enableGnomeKeyring = true;
        kwallet.enable = lib.mkForce false;
      };
    };

    programs.xwayland.enable = true;
    i18n.inputMethod.fcitx5.plasma6Support = true;
  };
}

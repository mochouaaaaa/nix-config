{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {

    i18n.inputMethod = {
      fcitx5 = {
        fcitx5-with-addons = lib.mkForce pkgs.kdePackages.fcitx5-with-addons;
        addons = lib.mkBefore (with pkgs; [ kdePackages.fcitx5-configtool ]);
      };
    };

    home.sessionVariables = {
      IM_MODULE_CLASSNAME = "fcitx::QFcitxPlatformInputContext";
    };

  };
}

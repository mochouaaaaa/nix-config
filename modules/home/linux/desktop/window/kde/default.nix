{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  imports = self.importModule' ./.;

  options.modules.desktop.kde = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "kde";
      description = "Enable KDE desktop environment.";
    };
  };

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

    qt.style.name = "kvantum";

    modules.themes.auto = {
      enable = true;
      kdeTheme.enable = true;
    };

    services.xremap.withKDE = lib.mkForce true;

  };
}

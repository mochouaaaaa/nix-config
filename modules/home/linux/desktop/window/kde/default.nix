{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.desktop.kde;
in {
  imports = [
    ./packages.nix
    ./plasma.nix
  ];

  options.modules.desktop.kde.enable = lib.mkEnableOption "KDE desktop environment" // {default = false;};

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        fcitx5-with-addons = lib.mkForce pkgs.kdePackages.fcitx5-with-addons;
        addons = lib.mkBefore (with pkgs; [kdePackages.fcitx5-configtool]);
      };
    };
  };
}

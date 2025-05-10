{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.desktop.kde;
in
{
  imports = [
    ./packages.nix
    ./plasma.nix
  ];

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

    services.xremap.withKDE = lib.mkForce true;

    modules.packages.kitty.extraConfig = lib.mkAfter [
      "hide_window_decorations yes"
    ];
  };
}

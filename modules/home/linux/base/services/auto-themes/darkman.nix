{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.themes.auto;
  cfgDesktop = config.modules'.desktop;
in
{
  options.modules'.themes.auto = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable auto-theme based on time and location.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        whitesur-icon-theme
        whitesur-cursors
      ]
      ++ lib.optionals (cfgDesktop.kde.enable) [ whitesur-kde ]
      ++ lib.optionals (!cfgDesktop.kde.enable) [
        libadwaita
        (whitesur-gtk-theme.override {
          altVariants = [ "all" ];
          nautilusStyle = "mojave";
          roundedMaxWindow = true;
          darkerColor = true;
        })
      ];

    services.darkman = {
      enable = true;
      settings = {
        lat = 39.9042;
        lng = 116.4074;
        usegeoclue = true;
      };
    };
  };
}

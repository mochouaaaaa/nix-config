{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.themes.auto;
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
    home.packages = with pkgs; [
      libadwaita
    ];

    services.darkman = {
      enable = true;
      settings = {
        lat = 39.9042;
        lng = 116.4074;
        usegeoclue = true;
        portal = true;
      };
    };
  };
}

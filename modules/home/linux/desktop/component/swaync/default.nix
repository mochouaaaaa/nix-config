{
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktop.component.swaync;

  jsonFile = builtins.readFile ./config.json;
  settings = builtins.fromJSON jsonFile;
in {
  options.modules.desktop.component.swaync = {
    enable = lib.mkEnableOption "swaync" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = settings;
      style = ''
        @import '../../.cache/wal/colors-waybar.css';
        @import 'themes/nova-dark/notifications.css';
        @import 'themes/nova-dark/central_control.css';
      '';
    };

    xdg.configFile = {
      "swaync/icons" = {
        source = ./icons;
        recursive = true;
        force = true;
      };
      "swaync/themes" = {
        source = ./themes;
        recursive = true;
        force = true;
      };
    };
  };
}

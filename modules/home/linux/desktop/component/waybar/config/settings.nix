{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.desktop.component.waybar;
  cfg-settings = config.programs'.waybar'.settings;
in
{

  options.programs'.waybar'.settings = {
    modules-left = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of modules to be displayed on the left side of the bar.";
    };
    modules-center = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of modules to be displayed in the center of the bar.";
    };

  };

  config = lib.mkIf cfg.enable {

    programs.waybar = {
      settings = [
        {
          include = "~/.config/waybar/modules";
          layer = "top";
          position = "top";
          height = 12;
          margin-left = 10;
          margin-right = 10;
          margin-top = 2;
          modules-left = [
            "custom/separator#blank"
            "custom/weather"
            "custom/separator#blank"
          ] ++ cfg-settings.modules-left;
          modules-center = [
            # "hyprland/workspaces"
          ] ++ cfg-settings.modules-center;
          modules-right = [
            "tray"
            "custom/separator#blank"
            "mpris"
            "custom/separator#blank"
            "group/motherboard"
            "custom/separator#blank"
            "group/laptop"
            "custom/separator#blank"
            "group/audio"
            "custom/separator#blank"
            "clock"
            "custom/separator#blank"
            "custom/power"
          ];
          "custom/power" = {
            icon-size = 20;
            on-click = "wlogout -C $HOME/.config/wlogout/nova.css -l $HOME/.config/wlogout/layout -b 5 -B400 -T 400";
            tooltip = false;
          };
          clock = {
            format = "{:%H:%M - %d/%b}";
            tooltip = false;
          };
        }
      ];

    };
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.component.rofi;

  keymaps =
    [
      {
        "SUPER-SPACE" = {
          launch = [
            "bash"
            "-c"
            "rofi -show drun"
          ];
        };
        "SUPER-P" = {
          launch = [
            "bash"
            "-c"
            "rofi-cliphist -f $HOME/.config/rofi/rofi-cliphist.toml"
          ];
        };
      }
    ]
    ++ lib.optionals (config.programs.waybar.enable) [
      {
        "SUPER-CTRL-SHIFT-I" = {
          launch = [ "select-wallpaper" ];
        };
      }
    ];

in
{
  imports = [
    ./scripts
    ./themes
  ];

  options.modules.desktop.component.rofi = {
    enable = lib.mkEnableOption "Rofi" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-rbw-wayland
        rofi-calc
        rofi-emoji
      ];
    };

    xdg.configFile = {
      "rofi/colors" = {
        source = ./colors;
        recursive = true;
        force = true;
      };
    };

    modules.shortcuts.global = lib.mkAfter keymaps;

  };
}

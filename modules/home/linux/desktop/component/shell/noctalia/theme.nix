{ config, lib, ... }:
let
  cfg = config.programs.noctalia;
in
{
  config = lib.mkIf (cfg.enable) {
    programs.noctalia = {
      settings = {
        colorSchemes = {
          darkMode = true;
          generationMethod = "fruit-salad";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          predefinedScheme = "Catppuccin";
          schedulingMode = "location";
          useWallpaperColors = true;
        };
        theme = {
          custom_palette = "summer-scene-light-fs";
          mode = "auto";
          pure_black_dark = true;
          source = "wallpaper";
          wallpaper_scheme = "m3-fruit-salad";
          templates = {
            builtin_ids = [
              "alacritty"
              "btop"
              "cava"
              "gtk3"
              "gtk4"
              "hyprland"
              "kcolorscheme"
              "kitty"
              "niri"
              "qt"
              "wezterm"
            ];
            community_ids = [
              "feishin"
              "spicetify"
              "pywalfox"
              "pywalfox-beta4"
              "zen-browser"
              "discord"
              "telegram"
              "obsidian"
              "vscode"
              "zed"
              "steam"
              "vicinae"
              "obs"
              "bat"
              "lazygit"
              "yazi"
            ];
          };
        };
      };
    };

    services.vicinae = {
      settings = {
        theme = {
          light = {
            name = lib.mkForce "noctalia";
          };
          dark = {
            name = lib.mkForce "noctalia";
          };
        };
        launcher_window = {
          opacity = lib.mkForce 0.68;
        };
      };
    };

    profiles.packages.terminal.kitty.extraConfig = lib.mkAfter [
      "include themes/noctalia.conf"
    ];

    programs.helix.settings = {
      theme = "noctalia";
    };

    programs.zed-editor.userSettings = {
      theme = {
        light = "Noctalia Light";
        dark = "Noctalia Dark";
      };
    };

    programs.emacs.extraConfig = lib.optionalString (config.programs.emacs.enable) ''
      (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
      (load-theme 'noctalia t)
    '';

  };
}

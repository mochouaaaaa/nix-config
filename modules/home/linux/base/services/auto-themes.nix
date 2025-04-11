{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.themes.auto;
in
{

  options.modules.themes.auto = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable auto-theme based on time and location.";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      whitesur-icon-theme
      whitesur-gtk-theme
      whitesur-cursors
    ];

    services.darkman = {
      enable = true;
      settings = {
        lat = 39.9042;
        lng = 116.4074;
        usegeoclue = true;
      };
      lightModeScripts = {
        gtk-theme = ''
          notify-send --app-name="darkman" --urgency=low --icon=$HOME/.config/swaync/icons/switch_dark.png "switching to light mode"
          dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
          dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
          dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-light'"
          dconf write /org/gnome/desktop/interface/cursor-theme "'Capitaine Cursors (Nord) - White'"

        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          notify-send --app-name="darkman" --urgency=low --icon=$HOME/.config/swaync/icons/switch_light.png "switching to dark mode"
          dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
          dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
          dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-dark'"
          dconf write /org/gnome/desktop/interface/cursor-theme "'Capitaine Cursors (Nord)'"

        '';
      };
    };
  };
}

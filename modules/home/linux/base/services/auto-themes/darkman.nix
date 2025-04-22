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
      (whitesur-gtk-theme.override {
        altVariants = [ "all" ];
        nautilusStyle = "mojave";
        roundedMaxWindow = true;
      })
      whitesur-cursors

      (writeShellScriptBin "switch-theme" ''

        theme=$1

        if [[ $theme == "light" ]]; then
          dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
          dconf write /org/gnome/desktop/interface/gtk-theme "'Whitesur-light'"
          dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-light'"
          # 对firefox无效
          # dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-light'"
          dconf write /org/gnome/desktop/interface/cursor-theme "'Capitaine Cursors (Nord) - White'"
          dconf write /org/gnome/desktop/interface/name-theme "'WhiteSur-light'"

        elif [[ $theme == "dark" ]]; then
          dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
          dconf write /org/gnome/desktop/interface/gtk-theme "'Whitesur-dark'"
          dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
          # dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-dark'"
          dconf write /org/gnome/desktop/interface/cursor-theme "'Capitaine Cursors (Nord)'"
          dconf write /org/gnome/desktop/interface/name-theme "'WhiteSur-dark'"

        fi

        ln -sf $HOME/.config/gtk-3.0/settings-''${theme}.ini $HOME/.config/gtk-3.0/settings.ini
        ln -sf $HOME/.config/gtk-4.0/settings-''${theme}.ini $HOME/.config/gtk-4.0/settings.ini

        notify-send --app-name="darkman" --urgency=low --icon=$HOME/.config/swaync/icons/switch_''${theme}.png "switching to ''${theme} mode"

      '')
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
          switch-theme light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          switch-theme dark
        '';
      };
    };
  };
}

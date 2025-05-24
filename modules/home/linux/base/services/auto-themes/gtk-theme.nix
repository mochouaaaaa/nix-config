{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.themes.auto.gtkTheme;
in
{

  options.modules.themes.auto = {
    gtkTheme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GTK theme.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [

      (writeShellScriptBin "switch-gtk2-config" ''
        theme=$1

        cat > $HOME/.gtkrc-2.0 << EOF         
        gtk-enable-animations=1
        gtk-theme-name="WhiteSur-$theme"
        gtk-primary-button-warps-slider=1
        gtk-toolbar-style=0
        gtk-menu-images=1
        gtk-button-images=1
        gtk-cursor-theme-size=36
        gtk-sound-theme-name="ocean"
        gtk-cursor-theme-name="WhiteSur-cursors"
        gtk-icon-theme-name="WhiteSur-$theme"
        gtk-font-name="Monaco Nerd Font Mono, 12"
        EOF
      '')

      (writeShellScriptBin "switch-theme" ''

        theme=$1

        switch-gtk2-config $theme

        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$theme'"
        dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-$theme'"
        dconf write /org/gnome/desktop/interface/name-theme "'WhiteSur-$theme'"

        if [[ $theme == "light" ]]; then
          # Adwaita-dark
          dconf write /org/gnome/desktop/interface/gtk-theme "'Whitesur-Light'"
          dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Light'"

        elif [[ $theme == "dark" ]]; then
          dconf write /org/gnome/desktop/interface/gtk-theme "'Whitesur-Dark'"
          dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Dark'"
        fi

        ln -sf $HOME/.config/gtk-3.0/settings-''${theme}.ini $HOME/.config/gtk-3.0/settings.ini
        ln -sf $HOME/.config/gtk-4.0/settings-''${theme}.ini $HOME/.config/gtk-4.0/settings.ini

        notify-send --app-name="darkman" --urgency=low --icon=$HOME/.config/swaync/icons/switch_''${theme}.png "switching to ''${theme} mode"

      '')
    ];

    services.darkman = {
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

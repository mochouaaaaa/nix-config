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

        # gtk_theme_name="Adwaita-light"
        gtk_theme_name="WhiteSur-Light"
        if [ "$theme" = "dark" ]; then
          gtk_theme_name="WhiteSur-Dark"
          # gtk_theme_name="Adwaita-dark"
        fi

        cat > $HOME/.gtkrc-2.0 << EOF         
        gtk-enable-animations=1
        gtk-theme-name="$gtk_theme_name"
        gtk-primary-button-warps-slider=1
        gtk-toolbar-style=0
        gtk-menu-images=1
        gtk-button-images=1
        gtk-cursor-theme-size=24
        gtk-sound-theme-name="ocean"
        gtk-cursor-theme-name="WhiteSur-cursors"
        gtk-icon-theme-name="WhiteSur-$theme"
        gtk-font-name="Monaco Nerd Font Mono, 12"
        EOF
      '')

      (writeShellScriptBin "switch-theme" ''

        theme_mode=$1

        switch-gtk2-config $theme_mode

        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$theme_mode'"
        dconf write /org/gnome/desktop/interface/cursor-size 24
        dconf write /org/gnome/desktop/interface/cursor-theme "'WhiteSur-cursors'"
        dconf write /org/gnome/desktop/interface/font-antialiasing "'grayscale'"
        dconf write /org/gnome/desktop/interface/font-hinting "'slight'"
        dconf write /org/gnome/desktop/interface/font-name "'Monaco Nerd Font Mono 12'"
        dconf write /org/gnome/desktop/interface/font-rgba "'rgb'"
        dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-$theme_mode'"
        dconf write /org/gnome/desktop/interface/text-scaling-factor 1.0

        rm -rf $HOME/.config/gtk-4.0/gtk-dark.css
        rm -rf $HOME/.config/gtk-4.0/gtk.css
        # WhiteSur-Dark/Light         Adwaita-dark
        if [[ $theme_mode == "light" ]]; then
          dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Light'"
          # dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Light'"

          
          cat ${pkgs.whitesur-gtk-theme}/share/themes/WhiteSur-Light/gtk-3.0/gtk-dark.css > $HOME/.config/gtk-4.0/gtk-dark.css
          cat ${pkgs.whitesur-gtk-theme}/share/themes/WhiteSur-Light/gtk-3.0/gtk.css > $HOME/.config/gtk-4.0/gtk.css

        elif [[ $theme_mode == "dark" ]]; then
          dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'"
          # dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Dark'"

          cat ${pkgs.whitesur-gtk-theme}/share/themes/WhiteSur-Dark/gtk-3.0/gtk-dark.css > $HOME/.config/gtk-4.0/gtk-dark.css

          cat ${pkgs.whitesur-gtk-theme}/share/themes/WhiteSur-Dark/gtk-3.0/gtk.css > $HOME/.config/gtk-4.0/gtk.css
        fi

        ln -sf $HOME/.config/gtk-3.0/settings-''${theme_mode}.ini $HOME/.config/gtk-3.0/settings.ini

        notify-send --app-name="darkman" --urgency=low --icon=$HOME/.config/swaync/icons/switch_''${theme_mode}.png "switching to ''${theme_mode} mode"

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

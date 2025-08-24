{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.themes.auto.gtkTheme;
in
{

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      cfg.package
      cfg.icon.package

      (writeShellScriptBin "switch-gtk2-config" ''
        # 第一个参数：模式 (Dark 或 Light)
        mode=''${1:-${cfg.light}}  # 如果没有提供 mode 参数，默认是 Light

        # 第二个参数：主题名称
        theme=''${2:-${cfg.name}}  # 如果没有提供 theme 参数，默认是 Colloid

        # 第三个参数：图标主题名称
        icon_theme=''${3:-${cfg.icon.name}}  # 如果没有提供 icon_theme 参数，默认是 Colloid

        # 默认主题是 Colloid
        gtk_theme_name="$theme-$mode"
        gtk_icon_theme="$icon_theme-$mode"

        cat > $HOME/.gtkrc-2.0 << EOF         
        gtk-enable-animations=1
        gtk-theme-name="$gtk_theme_name"
        gtk-primary-button-warps-slider=1
        gtk-toolbar-style=0
        gtk-menu-images=1
        gtk-button-images=1
        gtk-cursor-theme-size=${builtins.toString config.home.pointerCursor.size}
        gtk-sound-theme-name="ocean"
        gtk-cursor-theme-name="${config.home.pointerCursor.name}"
        gtk-icon-theme-name="$gtk_icon_theme"
        gtk-font-name="Monaco Nerd Font Mono, 12"
        EOF
      '')

      (writeShellScriptBin "switch-gtk3and4-config" ''
        mode=''${1:-${cfg.light}}  # 如果没有提供 mode 参数，默认是 Light
        theme=''${2:-${cfg.name}}  # 如果没有提供 theme 参数，默认是 Colloid
        icon_theme=''${3:-${cfg.icon.name}}  # 如果没有提供 icon_theme 参数，默认是 Colloid

        # 默认主题是 Colloid
        gtk_theme_name="$theme-$mode"
        gtk_icon_theme="$icon_theme-$mode"

        # 根据模式设置 gtk-application-prefer-dark-theme 的值
        if [ "$mode" = "Dark" ]; then
            prefer_dark=1
        else
            prefer_dark=0
        fi

        function set_gtk_theme {
            local gtk_version=$1
            local config_dir="$XDG_CONFIG_HOME/gtk-$gtk_version.0"
            local config_file="$config_dir/settings.ini"

            mkdir -p "$config_dir"

            # 使用 cat 生成配置文件
            cat > "$config_file" << EOF
        [Settings]
        gtk-key-theme-name=Default
        gtk-theme-name=$gtk_theme_name
        gtk-icon-theme-name=$gtk_icon_theme
        gtk-font-name=Monaco Nerd Font 12
        gtk-cursor-theme-name=${config.home.pointerCursor.name}
        gtk-cursor-theme-size=${builtins.toString config.home.pointerCursor.size}
        gtk-button-images=0
        gtk-menu-images=0
        gtk-enable-event-sounds=0
        gtk-enable-input-feedback-sounds=0
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
        gtk-application-prefer-dark-theme=$prefer_dark
        EOF
        }

        set_gtk_theme 3
        set_gtk_theme 4
      '')

      (writeShellScriptBin "switch-theme" ''
        mode=''${1:-${cfg.light}}  # 如果没有提供 mode 参数，默认是 Light
        theme=''${2:-${cfg.name}}  # 如果没有提供 theme 参数，默认是 Colloid
        icon_theme=''${3:-${cfg.icon.name}}  # 如果没有提供 icon_theme 参数，默认是 Colloid

        # 默认主题是 Colloid
        gtk_theme_name="$theme-$mode"
        gtk_icon_theme="$icon_theme-$mode"

        switch-gtk2-config $mode $theme $icon_theme
        switch-gtk3and4-config $mode $theme $icon_theme

        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-''${mode,,}'"
        dconf write /org/gnome/desktop/interface/cursor-size ${builtins.toString config.home.pointerCursor.size}
        dconf write /org/gnome/desktop/interface/cursor-theme "'${config.home.pointerCursor.name}'"
        dconf write /org/gnome/desktop/interface/font-antialiasing "'grayscale'"
        dconf write /org/gnome/desktop/interface/font-hinting "'slight'"
        dconf write /org/gnome/desktop/interface/font-name "'Monaco Nerd Font Mono 12'"
        dconf write /org/gnome/desktop/interface/font-rgba "'rgb'"
        dconf write /org/gnome/desktop/interface/text-scaling-factor 1.0
        dconf write /org/gnome/desktop/interface/gtk-key-theme "'Default'"
        dconf write /org/gnome/desktop/interface/icon-theme "'$gtk_icon_theme'"
        dconf write /org/gnome/desktop/interface/gtk-theme "'$gtk_theme_name'"
        dconf write /org/gnome/shell/extensions/user-theme/name "'$gtk_theme_name'"


        # notify-send --app-name="darkman" --urgency=low --icon=$HOME/.config/swaync/icons/switch_''${mode}.png "switching to ''${mode} mode"

      '')

    ];

    services.darkman = {
      lightModeScripts = {
        gtk-theme = ''
          switch-theme Light
        '';
      };
      darkModeScripts = {
        gtk-theme = ''
          switch-theme Dark
        '';
      };
    };

  };
}

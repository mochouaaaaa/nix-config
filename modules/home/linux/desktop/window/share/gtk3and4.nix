{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop;
  cfgTheme = config.profiles.themes.gtkTheme;

  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland

  switch-gtk2-config = pkgs.writeShellScriptBin "switch-gtk2-config" ''

    cat > $HOME/.gtkrc-2.0 << EOF         
    gtk-enable-animations=1
    gtk-theme-name="$1"
    gtk-primary-button-warps-slider=1
    gtk-toolbar-style=0
    gtk-menu-images=1
    gtk-button-images=1
    gtk-cursor-theme-size=${toString config.home.pointerCursor.size}
    gtk-sound-theme-name="ocean"
    gtk-cursor-theme-name="${config.home.pointerCursor.name}"
    gtk-icon-theme-name="$2"
    gtk-font-name="${config.profiles.fonts.default}, 12"
    EOF
  '';

  switch-gtk3and4-config = pkgs.writeShellScriptBin "switch-gtk3and4-config" ''
    mode=$1
    gtk_theme_name=$2
    gtk_icon_theme=$3

    function set_gtk_theme {
        local gtk_version=$1
        local config_dir="$XDG_CONFIG_HOME/gtk-$gtk_version.0"
        local config_file="$config_dir/settings.ini"

        mkdir -p "$config_dir"

        # 使用 cat 生成配置文件
        cat > "$config_file" << EOF
    [Settings]
    gtk-theme-name=$gtk_theme_name
    gtk-icon-theme-name=$gtk_icon_theme
    gtk-font-name=${config.profiles.fonts.default} 12
    gtk-cursor-theme-name=${config.home.pointerCursor.name}
    gtk-cursor-theme-size=${toString config.home.pointerCursor.size}
    gtk-button-images=0
    gtk-menu-images=0
    gtk-enable-event-sounds=1
    gtk-enable-input-feedback-sounds=0
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintslight
    gtk-xft-rgba=rgb
    gtk-application-prefer-dark-theme=$mode
    EOF
    }

    set_gtk_theme 3
    # set_gtk_theme 4
  '';

  switch-theme = pkgs.writeShellScriptBin "switch-theme" ''
    mode=''${1:-light} 

    if [[ "''${mode,,}" == "dark" ]]; then
        prefer_dark=1
    else
        prefer_dark=0
    fi

    declare -A GTK_THEME_MAP=(
        [light]="${cfgTheme.name}${if cfgTheme.light != "" then "-${cfgTheme.light}" else ""}"
        [dark]="${cfgTheme.name}${if cfgTheme.dark != "" then "-${cfgTheme.dark}" else ""}"
    )

    declare -A GTK_ICON_MAP=(
        [light]="${cfgTheme.icon.name}${
          if cfgTheme.icon.light != "" then "-${cfgTheme.icon.light}" else ""
        }"
        [dark]="${cfgTheme.icon.name}${
          if cfgTheme.icon.dark != "" then "-${cfgTheme.icon.dark}" else ""
        }"
    )

    gtk_theme_name="''${GTK_THEME_MAP[$mode]}"
    gtk_icon_theme="''${GTK_ICON_MAP[$mode]}"

    ${lib.getExe switch-gtk2-config} $gtk_theme_name $gtk_icon_theme
    ${lib.getExe switch-gtk3and4-config} $prefer_dark $gtk_theme_name $gtk_icon_theme
    ${lib.getExe dconf-settings}
  '';

  dconf-settings = pkgs.writeShellScriptBin "dconf-settings" ''
    config="''${XDG_CONFIG_HOME:-''$HOME/.config}/gtk-3.0/settings.ini"
    if [ ! -f "$config" ]; then exit 1; fi

    dconf=${lib.getExe pkgs.dconf}
    gnome_schema="/org/gnome/desktop/interface/"
    color_theme=$(grep 'gtk-application-prefer-dark-theme' "$config" | sed 's/.*\s*=\s*//')
    gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
    icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
    cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
    font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"

    $dconf reset -f /org/gnome/
    $dconf write ''${gnome_schema}gtk-theme "'$gtk_theme'"
    $dconf write ''${gnome_schema}icon-theme "'$icon_theme'"
    $dconf write ''${gnome_schema}cursor-theme "'$cursor_theme'"
    $dconf write ''${gnome_schema}font-name "'$font_name'"


    if [[ "$color_theme" == "1" ]]; then
        COLOR_SCHEME="prefer-dark"
    else
        COLOR_SCHEME="prefer-light"
    fi
    $dconf write ''${gnome_schema}color-scheme "'$COLOR_SCHEME'"

  '';

in
{

  options.profiles.themes = {
    gtkTheme = rec {
      package = lib.mkOption {
        type = lib.types.package;
        default = (
          pkgs.colloid-gtk-theme.override {
            tweaks = [ "black" ];
          }
        );
        description = "GTK theme package.";
      };
      icon = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "Colloid";
          description = "Name of GTK icon theme.";
        };
        package = lib.mkOption {
          type = lib.types.package;
          # default = pkgs.colloid-icon-theme;
          default = pkgs.colloid-icon-theme.overrideAttrs (oldAttrs: {
            version = "2025-07-19";
            src = pkgs.fetchFromGitHub {
              owner = "vinceliuice";
              repo = "colloid-icon-theme";
              tag = "2025-07-19";
              hash = "sha256-CzFEMY3oJE3sHdIMQQi9qizG8jKo72gR8FlVK0w0p74=";
            };
            dontWrapQtApps = true;
            propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ pkgs.kdePackages.breeze ];
            postInstall = (oldAttrs.postInstall or "") + ''
              rm -f $out/share/icons/Colloid-Light/apps/scalable/io.github.vinegarhq.Vinegar.studio.svg
            '';
          });
          description = "Icon theme package.";
        };
        dark = dark;
        light = light;
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Colloid";
        description = "Name of GTK theme.";
      };
      dark = lib.mkOption {
        type = lib.types.str;
        default = "Dark";
        description = "Name of GTK dark theme.";
      };
      light = lib.mkOption {
        type = lib.types.str;
        default = "Light";
        description = "Name of GTK light theme.";
      };
    };

  };

  config = lib.mkIf (cfg.gnome.enable || cfg.hyprland.enable || cfg.niri.enable) {

    profiles.themes.gtkTheme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
      icon = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        dark = "";
        light = "";
      };
      dark = "dark";
      light = "";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        text-scaling-factor = lib.hm.gvariant.mkDouble 1.0;
        toolbar-style = lib.hm.gvariant.mkString "large";
        toolbar-icons-size = lib.hm.gvariant.mkString "both-horiz";
        font-name = lib.hm.gvariant.mkString "${config.profiles.fonts.default} 12";
      };
    };

    home.packages = [
      cfgTheme.package
      cfgTheme.icon.package
      switch-theme
    ];

  };
}

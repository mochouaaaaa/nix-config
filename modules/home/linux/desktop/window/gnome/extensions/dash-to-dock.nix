{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgGnome = config.profiles.desktop.gnome;
  cfg = config.profiles.desktop.gnome.extensions.dash-to-dock;
in
{
  config = lib.mkIf (cfgGnome.enable && cfg) {
    programs.gnome-shell = {
      extensions = [
        { package = pkgs.gnomeExtensions.dash-to-dock; }
      ];
    };

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = lib.gvariant.mkArray [
          "firefox.desktop"
          "org.gnome.Nautilus.desktop"
          "kitty.desktop"
          "io.github.kukuruzka165.materialgram.desktop"
          "org.telegram.desktop"
          "code.desktop"
        ];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = lib.gvariant.mkBoolean false;
        dock-position = lib.gvariant.mkString "BOTTOM";
        icon-size-fixed = lib.gvariant.mkBoolean false;
        preferred-monitor = lib.gvariant.mkInt32 (-2);
        transparency-mode = lib.gvariant.mkString "DYNAMIC";
        autohide-in-fullscreen = true;
        background-color = "rgb(128,128,128)";
        background-opacity = 0.0;
        click-action = "focus-minimize-or-previews";
        custom-background-color = false;
        custom-theme-shrink = true;
        dash-max-icon-size = 48;
        dock-fixed = false;
        extend-height = false;
        height-fraction = 0.90000000000000002;
        hide-tooltip = true;
        hot-keys = false;
        intellihide = true;
        intellihide-mode = "ALL_WINDOWS";
        preferred-monitor-by-connector = "DP-1";
        preview-size-scale = 1.0;
        show-apps-at-top = false;
        show-icons-emblems = true;
        show-mounts = false;
        show-mounts-network = true;
        show-mounts-only-mounted = true;
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
in
{
  # Centralized options for all GNOME Shell extensions.
  # This makes managing them easier and simplifies individual module files.
  options.modules'.desktop.gnome.extensions = with lib; {
    appindicator = mkEnableOption "AppIndicator and KStatusNotifierItem Support";
    auto-move-windows = mkEnableOption "Auto Move Windows";
    blur-my-shell = mkEnableOption "Blur My Shell";
    burn-my-windows = mkEnableOption "Burn My Windows";
    clipboard-indicator = mkEnableOption "Clipboard Indicator";
    coverflow-alt-tab = mkEnableOption "Coverflow Alt-Tab";
    dash-to-dock = mkEnableOption "Dash to Dock";
    fildem = mkEnableOption "Fildem (custom build)";
    forge = mkEnableOption "Forge (tiling)";
    fuzzy-app-search = mkEnableOption "Fuzzy App Search";
    hide-top-bar = mkEnableOption "Hide Top Bar";
    just-perfection = mkEnableOption "Just Perfection";
    kimpanel = mkEnableOption "Kimpanel (for Fcitx5)";
    logo-menu = mkEnableOption "Logo Menu";
    rounded-window-corners-reborn = mkEnableOption "Rounded Window Corners";
    settingscenter = mkEnableOption "Settings Center";
    system-monitor = mkEnableOption "System Monitor";
    text-clock = mkEnableOption "Text Clock";
    tray-icons-reloaded = mkEnableOption "Tray Icons: Reloaded";
    unite = mkEnableOption "Unite";
    user-avatar-in-quick-settings = mkEnableOption "User Avatar in Quick Settings";
    user-themes = mkEnableOption "User Themes";
    workflow = mkEnableOption "Static Workspace and dconf workflow settings";
    xremap = mkEnableOption "Xremap (for key remapping)";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gnome.monitors.enable = true;
      gnome-shell.enable = true;
    };

    home.packages = with pkgs; [
      gnome-tweaks
      dconf-editor
    ];

    # Set the defaults for the newly defined centralized options.
    # These were previously set in this file or in the individual extension files.
    modules'.desktop.gnome.extensions = {
      appindicator = true;
      auto-move-windows = true;
      coverflow-alt-tab = true;
      dash-to-dock = true;
      just-perfection = true;
      logo-menu = true;
      rounded-window-corners-reborn = true;
      settingscenter = true;
      unite = true;
      user-themes = true;
    };
  };
}

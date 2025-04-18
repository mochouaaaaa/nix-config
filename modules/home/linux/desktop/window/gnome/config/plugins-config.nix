{ lib, ... }:
{
  "org/gnome/shell/extensions/SettingsCenter" = {
    items = lib.gvariant.mkString "Gnome Config Editor;gconf-editor.desktop;1;gconf-editor|Gnome Tweaks;gnome-tweaks.desktop;1;gnome-tweaks|Desktop Config Editor;dconf-editor.desktop;1;dconf-editor|Extensions Preferences;org.gnome.Extensions.desktop;1;gnome-extensions-app|NVidia Settings;nvidia-settings.desktop;0;nvidia-settings|Passwords and Keys;seahorse.desktop;1;seahorse|PulseAudio;pavucontrol.desktop;1;pavucontrol|Session Properties;session-properties.desktop;0;gnome-session-properties";
  };

  "org/gnome/shell/extensions/appindicator" = {
    tray-pos = lib.hm.gvariant.mkString "right";
  };

  "org/gnome/shell/extensions/auto-move-windows" = {
    "application-list" = [
      "firefox.desktop:2"
      "com.obsproject.Studio.desktop:4"
    ];
  };
  "org/gnome/shell/extensions/user-theme" = {
    name = lib.gvariant.mkString "";
  };
  "org/gnome/shell/extensions/blur-my-shell" = {
    hacks-level = lib.gvariant.mkInt32 1;
    settings-version = lib.hm.gvariant.mkInt32 2;
    pipelines = ''{'pipeline_default': {'name': 'Default','effects': [{'type': 'native_static_gaussian_blur','id': 'effect_000000000000','params': {'radius': 30,'brightness': 0.6}}]},'pipeline_default_rounded': {'name': 'Default rounded','effects': [{'type': 'native_static_gaussian_blur','id': 'effect_000000000001','params': {'radius': 30,'brightness': 0.6}},{'type': 'corner','id': 'effect_000000000002','params': {'radius': 16}}]}}'';
  };
  "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
    sigma = 37;
  };
  "org/gnome/shell/extensions/blur-my-shell/applications" = {
    blur = true;
    blur-on-overview = true;
    brightness = 1.0;
    dynamic-opacity = false;
    enable-all = true;
    opacity = 255;
    sigma = 11;
  };
  "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
    blur = true;
    pipeline = "pipeline_default";
  };
  "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
    pipeline = "pipeline_default";
    style-dash-to-dock = 1;
    unblur-in-overview = true;
  };
  "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
    blur-original-panel = true;
  };
  "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
    pipeline = "pipeline_default";
    compatibility = true;
  };
  "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
    pipeline = "pipeline_default";
  };
  "org/gnome/shell/extensions/blur-my-shell/overview" = {
    pipeline = "pipeline_default";
    style-components = 3;
  };

  "org/gnome/shell/extensions/blur-my-shell/panel" = {
    force-light-text = true;
    override-background = true;
    override-background-dynamically = true;
    pipeline = "pipeline_default";
    static-blur = true;
    style-panel = 0;
    unblur-in-overview = true;
  };
  "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
    pipeline = "pipeline_default";
  };
  "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
    sigma = 40;
  };
  "org/gnome/shell/extensions/burn-my-windows" = {
    active-profile = "/home/mochou/.config/burn-my-windows/profiles/1742968467993684.conf";
    last-extension-version = 46;
    last-prefs-version = 46;
    prefs-open-count = 11;
  };
  "org/gnome/shell/extensions/clipboard-indicator" = {
    enable-keybindings = lib.gvariant.mkBoolean false;
    history-size = lib.gvariant.mkInt32 100;
    notify-on-copy = lib.gvariant.mkBoolean false;
    paste-on-select = lib.gvariant.mkBoolean true;
    pinned-on-bottom = lib.gvariant.mkBoolean true;
  };
  "org/gnome/shell/extensions/coverflowalttab" = {
    dim-factor = 0.98999999999999999;
    # switcher-background-color = lib.gvariant.mkTuple [
    #   lib.gvariant.mkString
    #   "0.25098039215686274"
    #   lib.gvariant.mkString
    #   "0.25098039215686274"
    #   lib.gvariant.mkString
    #   "0.25098039215686274"
    # ];

    switcher-looping-method = "Flip Stack";
  };
  "org/gnome/shell/extensions/dash-to-dock" = {
    apply-custom-theme = lib.gvariant.mkBoolean true;
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

  "org/gnome/shell/extensions/trayIconsReloaded" = {
    applications = lib.gvariant.mkString "[{\"id\":\"bitwarden.desktop\",\"hidden\":false},{\"id\":\"org.telegram.desktop.desktop\",\"hidden\":false},{\"id\":\"pot.desktop\",\"hidden\":false}]";
    tray-position = lib.gvariant.mkString "right";
    icons-limit = lib.gvariant.mkInt32 4;
    icon-margin-horizontal = 0;
    icon-padding-horizontal = 0;
    icon-size = 22;
    invoke-to-workspace = true;
    position-weight = 0;
    tray-margin-right = 0;
    wine-behavior = true;
  };

  "org/gnome/shell/extensions/unite" = {
    app-menu-ellipsize-mode = lib.hm.gvariant.mkString "end";
    show-window-title = lib.hm.gvariant.mkString "tiled";
    window-buttons-placement = lib.hm.gvariant.mkString "first";
    app-menu-max-width = 0;
    autofocus-windows = true;
    enable-titlebar-actions = true;
    extend-left-box = false;
    greyscale-tray-icons = true;
    hide-app-menu-icon = true;
    hide-window-titlebars = "never";
    icon-scale-workaround = false;
    notifications-position = "right";
    reduce-panel-spacing = true;
    restrict-to-primary-screen = true;
    show-appmenu-button = true;
    show-desktop-name = false;
    show-legacy-tray = true;
    show-window-buttons = "tiled";
    use-activities-text = true;
    window-buttons-theme = "mcmojave";
  };
}

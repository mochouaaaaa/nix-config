{
  pkgs,
  lib,
  config,
  pkgs-unstable,
  pkgs-stable,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pkgs-stable.kdePackages.qt6gtk2
      hyprland-qt-support
      # hyprpolkitagent
      pantheon.pantheon-agent-polkit

      swaybg # the wallpaper
      # swaylock-effects
      wl-clipboard # copying and pasting
      hyprpicker # color picker
      envsubst

      pkgs-unstable.hyprshot # screen shot
      grimblast
      gimp
      # wf-recorder # screen recording

      wallust
      cliphist
      wttrbar
      parallel

      yad # a fork of zenity, for creating dialogs

      # audio
      alsa-utils # provides amixer/alsamixer/...
      mpd # for playing system sounds
      mpc-cli # command-line mpd client
      ncmpcpp # a mpd client with a UI
      networkmanagerapplet # provide GUI app: nm-connection-editor
    ];

    modules.packages.vscode.commandLineArgs = lib.mkAfter [
      "--gtk-version=4"
      "--ozone-platform-hint=auto"
      "--password-store=gnome"
    ];

  };
}

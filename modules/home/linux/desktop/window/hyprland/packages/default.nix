{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      pkgs-stable.kdePackages.qt6gtk2
      hyprland-qt-support

      swaybg # the wallpaper
      wl-clipboard # copying and pasting
      hyprpicker # color picker
      envsubst

      hyprshot # screen shot
      grimblast
      slurp
      gimp
      grim
      # wf-recorder # screen recording

      wallust
      cliphist
      parallel

      yad # a fork of zenity, for creating dialogs

      # audio
      alsa-utils # provides amixer/alsamixer/...
      pkgs-stable.mpd # for playing system sounds
      pkgs-stable.mpc-cli # command-line mpd client
      pkgs-stable.ncmpcpp # a mpd client with a UI
      pkgs-stable.networkmanagerapplet # provide GUI app: nm-connection-editor
    ];

  };
}

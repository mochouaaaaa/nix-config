{
  self,
  config,
  lib,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  imports = self.importModule' ./.;
  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      pkgs-stable.kdePackages.qt6gtk2
      hyprland-qt-support
      hyprpolkitagent

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
      pkgs-stable.mpd # for playing system sounds
      pkgs-stable.mpc-cli # command-line mpd client
      ncmpcpp # a mpd client with a UI
      networkmanagerapplet # provide GUI app: nm-connection-editor
    ];

  };
}

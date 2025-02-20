{
  pkgs,
  pkgs-unstable,
  lib,
  myvars,
  ...
}: let
  componentEnable = myvars.desktop.component;
in {
  imports = [] ++ lib.optionals componentEnable.waybar [./waybar] ++ lib.optionals componentEnable.swaync [./swaync] ++ lib.optionals componentEnable.wlogout [./wlogout] ++ lib.optionals componentEnable.swaylock [./swaylock] ++ lib.optionals componentEnable.rofi [./rofi];

  home.packages = with pkgs; [
    # waybar # the status bar
    swaybg # the wallpaper
    # swaylock-effects
    # wlogout # logout menu
    wl-clipboard # copying and pasting
    hyprpicker # color picker
    hypridle
    envsubst

    pkgs-unstable.hyprshot # screen shot
    grim # taking screenshots
    slurp # selecting a region to screenshot
    wf-recorder # screen recording

    swww
    wallust
    # rofi-wayland
    cliphist
    wttrbar

    yad # a fork of zenity, for creating dialogs

    # audio
    alsa-utils # provides amixer/alsamixer/...
    mpd # for playing system sounds
    mpc-cli # command-line mpd client
    ncmpcpp # a mpd client with a UI
    networkmanagerapplet # provide GUI app: nm-connection-editor
  ];

  home.file = lib.mkMerge [
    {}
    # (lib.mkIf componentEnable.wlogout {
    #   ".config/wlogout" = {
    #     source = ./wlogout;
    #     recursive = true;
    #     force = true;
    #   };
    # })
    # (lib.mkIf componentEnable.swaync {
    #   ".config/swaync" = {
    #     source = ./swaync;
    #     recursive = true;
    #     force = true;
    #   };
    # })
    # (lib.mkIf componentEnable.swaylock {
    #   ".config/swaylock" = {
    #     source = ./swaylock;
    #     recursive = true;
    #     force = true;
    #   };
    # })
    # (lib.mkIf componentEnable.rofi {
    #   ".config/rofi" = {
    #     source = ./rofi;
    #     recursive = true;
    #     force = true;
    #   };
    # })
  ];
}

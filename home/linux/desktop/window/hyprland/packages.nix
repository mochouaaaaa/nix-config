{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    swaybg # the wallpaper
    # swaylock-effects
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
}

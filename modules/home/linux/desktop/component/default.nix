{
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./rofi
    ./swaylock
    ./swaync
    ./waybar
    ./wlogout
  ];

  config = {
    home.packages = with pkgs; [
      pywal16
      ashell
      swaybg # the wallpaper
      wl-clipboard # copying and pasting
      envsubst

      pkgs-unstable.hyprshot # screen shot
      grim # taking screenshots
      slurp # selecting a region to screenshot
      wf-recorder # screen recording

      inputs.swww.packages.${pkgs.system}.swww
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
  };
}

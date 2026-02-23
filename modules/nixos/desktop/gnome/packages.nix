{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop.gnome;
in
{
  config = lib.mkIf cfg.enable {

    profiles.packages.steam.enable = lib.mkForce false;

    environment.systemPackages = with pkgs; [
      xev
      wev
      gdm-settings
      (marble-shell-theme.overrideAttrs (oldAttrs: {
        additionalInstallationTweaks = [
          "--launchpad -a"
        ];
        src = fetchFromGitHub {
          owner = "imarkoff";
          repo = "Marble-shell-theme";
          tag = "48.0.1";
          hash = "sha256-t/p8/Phl+DXbSVT8l3fonZQeoUTtrcfe4HiKB3D8KXw=";
        };
      }))
    ];

    environment.gnome.excludePackages = with pkgs; [
      gnome-software
      gnome-console
      gnome-terminal
      gnome-weather
      gnome-contacts
      gnome-music
      gnome-calculator
      gnome-maps
      gnome-contacts
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      evince # document viewer
      totem # video player
      yelp # Help view
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      gnome-initial-setup
    ];

  };
}

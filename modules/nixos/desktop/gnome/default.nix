{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.gnome;
in
{
  options.modules.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "gnome";
      description = "Enable GNOME desktop environment.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xorg.xev
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

    programs = {
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

    modules.dm.gdm.enable = true;

    services = {
      udisks2.enable = true;
      xserver = {
        enable = true;
        xkb.layout = "us";
      };
      desktopManager = {
        gnome.enable = true;
      };
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
        gnome-browser-connector.enable = true;
      };
      fwupd = {
        enable = true;
      };
      udev.packages = lib.mkAfter [ pkgs.gnome-settings-daemon ];
    };

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

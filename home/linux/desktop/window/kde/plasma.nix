{
  pkgs,
  lib,
  ...
}: let
  kwinKeymap = import ./keymap/kwin.nix;
  ksmserver = import ./keymap/ksmserver.nix;
  services = import ./keymap/app.nix;

  panels = import ./config/panels.nix;
in {
  programs.plasma = {
    enable = true;

    krunner = import ./config/krunner.nix {inherit lib;};
    fonts = import ./config/fonts.nix {};
    kwin = import ./config/kwin.nix;
    powerdevil = import ./config/powerdevil.nix;
    session = import ./config/session.nix;
    spectacle = import ./config/spectacle.nix;
    startup = import ./config/startup.nix;
    windows = import ./config/windows.nix;
    workspace = import ./config/workspace.nix;
    panels = [panels.MacOSXPanel];

    shortcuts =
      {
        kwin = kwinKeymap;
        ksmserver = ksmserver;
        plasmashell = import ./keymap/plasmashell.nix;
        kaccess = {
          "Toggle Screen Reader On and Off" = null;
        };
      }
      // services;
    configFile.kdeglobals.General = {
      TerminalApplication = "kitty";
      TerminalService = "kitty.desktop";
    };
  };
}

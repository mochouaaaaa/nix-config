{
  flake.modules.nixos."desktop.gnome" =
    {
      pkgs,
      lib,
      self,
      username,
      config,
      ...
    }:
    {
      imports = [
        self.modules.nixos."desktop.common"
      ];

      services = {
        xserver.enable = true;
        xserver.xkb.layout = "us";

        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;

        gnome.gnome-browser-connector.enable = true;

        udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
      };

      environment.systemPackages = with pkgs; [
        gdm-settings
        xev
        wev
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
        cheese
        epiphany
        geary
        evince
        totem
        yelp
        tali
        iagno
        hitori
        atomix
        gnome-initial-setup
        gnome-text-editor
        gnome-font-viewer
      ];

      home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
        self.modules.homeManager."desktop.gnome"
      ];
    };
}

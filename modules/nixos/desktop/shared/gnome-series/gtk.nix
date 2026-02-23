{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.desktop;
in
{

  config = lib.mkIf (!cfg.kde.enable) {

    programs = {
      seahorse.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

    environment = {
      systemPackages = with pkgs; [
        turtle # nautilus plugin git operation
        code-nautilus
        nautilus
        libadwaita
        gsettings-desktop-schemas
        glib
        mission-center
      ];
      sessionVariables = {
        ADW_DISABLE_PORTAL = 1;
      };
    };

    services = {
      dbus.packages = [
        # pkgs.turtle
        pkgs.mission-center
      ];
      gnome = {
        sushi.enable = true;
        gnome-settings-daemon.enable = true;
      };
      tumbler.enable = true; # Thumbnail support for images
      gvfs.enable = true; # Mount, trash, and other functionalities
    };

    programs.dconf.profiles = {
      user.databases = [
        {
          settings = {
            "org/gnome/nautilus/preferences" = {
              default-sort-order = "mtime";
              default-sort-in-reverse-order = true;
              default-folder-viewer = "list-view";
            };
          };

          locks = [
            "/org/gnome/nautilus/preferences/default-sort-order"
            "/org/gnome/nautilus/preferences/default-sort-in-reverse-order"
          ];
        }
      ];
    };

  };

}

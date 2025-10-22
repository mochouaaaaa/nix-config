# XDG stands for "Cross-Desktop Group", with X used to mean "cross".
# It's a bunch of specifications from freedesktop.org intended to standardize desktops and
# other GUI applications on various systems (primarily Unix-like) to be interoperable:
#   https://www.freedesktop.org/wiki/Specifications/
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.xdg-mime;
in
{

  options.modules'.xdg-mime = with lib; {
    editors = mkOption rec {
      type = types.listOf types.str;
      default = [ ];
      apply = userValue: default ++ userValue;
    };
    defaultApplications = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
    };
  };

  config = lib.mkIf (config.programs.desktop.enable) {
    home = {
      packages = with pkgs; [
        xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
        xdg-user-dirs
      ];
      shellAliases = {
        open = "xdg-open";
      };
    };

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        };
      };

      configFile."mimeapps.list".force = true;

      # manage $XDG_CONFIG_HOME/mimeapps.list
      # xdg search all desktop entries from $XDG_DATA_DIRS, check it by command:
      #  echo $XDG_DATA_DIRS
      # the system-level desktop entries can be list by command:
      #   ls -l /run/current-system/sw/share/applications/
      # the user-level desktop entries can be list by command(user ryan):
      #  ls /etc/profiles/per-user/<username>/share/applications/
      mimeApps = {
        enable = true;
        # let `xdg-open` to open the url with the correct application.
        defaultApplications =
          let
            editor = cfg.editors;
          in
          {
            "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

            "text/plain" = editor;
            "application/x-wine-extension-ini" = editor;
          }
          // cfg.defaultApplications;

        associations.removed = {
          # ......
        };
      };
    };

    xdg.portal = {
      enable = lib.mkDefault true;
      config = {
        common = {
          # Use xdg-desktop-portal-gtk for every portal interface...
          default = [
            "gtk"
            "gnome"
          ];
          # except for the secret portal, which is handled by gnome-keyring
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.Screenshot" = "gnome";
          "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
        };
      };

      # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
      # This will make xdg-open use the portal to open programs,
      # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
      # xdg-open is used by almost all programs to open a unknown file/uri
      # alacritty as an example, it use xdg-open as default, but you can also custom this behavior
      # and vscode has open like `External Uri Openers`
      xdgOpenUsePortal = true;
      configPackages = [ ];
      extraPortals = with pkgs; [
        xdg-desktop-portal
      ];
    };
  };
}

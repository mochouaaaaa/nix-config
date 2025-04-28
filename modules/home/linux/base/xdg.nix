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
  cfg = config.modules.xdg-mime;
in
{

  options.modules.xdg-mime = with lib; {
    editors = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

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
    #  ls /etc/profiles/per-user/mochou/share/applications/
    mimeApps = {
      enable = true;
      # let `xdg-open` to open the url with the correct application.
      defaultApplications =
        let
          editor = cfg.editors;
          file-roller = [ "org.gnome.FileRoller.desktop" ];
        in
        {

          "text/plain" = editor;
          "application/x-wine-extension-ini" = editor;

          # https://github.com/microsoft/vscode/issues/146408
          "x-scheme-handler/vscode" = [
            "code-url-handler.desktop"
          ]; # open `vscode://` url with `code-url-handler.desktop`
          "x-scheme-handler/vscode-insiders" = [
            "code-insiders-url-handler.desktop"
          ]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`

          "application/bzip2" = file-roller;
          "application/gzip" = file-roller;
          "application/vnd.android.package-archive" = file-roller;
          "application/vnd.ms-cab-compressed" = file-roller;
          "application/vnd.debian.binary-package" = file-roller;
          "application/vnd.rar" = file-roller;
          "application/x-7z-compressed" = file-roller;
          "application/x-7z-compressed-tar" = file-roller;
          "application/x-ace" = file-roller;
          "application/x-alz" = file-roller;
          "application/x-apple-diskimage" = file-roller;
          "application/x-ar" = file-roller;
          "application/x-archive" = file-roller;
          "application/x-arj" = file-roller;
          "application/x-brotli" = file-roller;
          "application/x-bzip-brotli-tar" = file-roller;
          "application/x-bzip" = file-roller;
          "application/x-bzip-compressed-tar" = file-roller;
          "application/x-bzip1" = file-roller;
          "application/x-bzip1-compressed-tar" = file-roller;
          "application/x-bzip3" = file-roller;
          "application/x-bzip3-compressed-tar" = file-roller;
          "application/x-cabinet" = file-roller;
          "application/x-cd-image" = file-roller;
          "application/x-compress" = file-roller;
          "application/x-compressed-tar" = file-roller;
          "application/x-cpio" = file-roller;
          "application/x-chrome-extension" = file-roller;
          "application/x-deb" = file-roller;
          "application/x-ear" = file-roller;
          "application/x-ms-dos-executable" = file-roller;
          "application/x-gtar" = file-roller;
          "application/x-gzip" = file-roller;
          "application/x-gzpostscript" = file-roller;
          "application/x-java-archive" = file-roller;
          "application/x-lha" = file-roller;
          "application/x-lhz" = file-roller;
          "application/x-lrzip" = file-roller;
          "application/x-lrzip-compressed-tar" = file-roller;
          "application/x-lz4" = file-roller;
          "application/x-lzip" = file-roller;
          "application/x-lzip-compressed-tar" = file-roller;
          "application/x-lzma" = file-roller;
          "application/x-lzma-compressed-tar" = file-roller;
          "application/x-lzop" = file-roller;
          "application/x-lz4-compressed-tar" = file-roller;
          "application/x-ms-wim" = file-roller;
          "application/x-rar" = file-roller;
          "application/x-rar-compressed" = file-roller;
          "application/x-rpm" = file-roller;
          "application/x-source-rpm" = file-roller;
          "application/x-rzip" = file-roller;
          "application/x-rzip-compressed-tar" = file-roller;
          "application/x-tar" = file-roller;
          "application/x-tarz" = file-roller;
          "application/x-tzo" = file-roller;
          "application/x-stuffit" = file-roller;
          "application/x-war" = file-roller;
          "application/x-xar" = file-roller;
          "application/x-xz" = file-roller;
          "application/x-xz-compressed-tar" = file-roller;
          "application/x-zip" = file-roller;
          "application/x-zip-compressed" = file-roller;
          "application/x-zstd-compressed-tar" = file-roller;
          "application/x-zoo" = file-roller;
          "application/zip" = file-roller;
          "application/zstd" = file-roller;

        };

      associations.removed = {
        # ......
      };
    };
  };
  xdg.portal = {
    enable = true;

    config = {
      common = {
        # Use xdg-desktop-portal-gtk for every portal interface...
        default = [ "gtk" ];
        # except for the secret portal, which is handled by gnome-keyring
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
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
}

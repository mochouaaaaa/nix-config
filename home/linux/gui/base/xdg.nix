# XDG stands for "Cross-Desktop Group", with X used to mean "cross".
# It's a bunch of specifications from freedesktop.org intended to standardize desktops and
# other GUI applications on various systems (primarily Unix-like) to be interoperable:
#   https://www.freedesktop.org/wiki/Specifications/
{
  config,
  pkgs,
  pkgs-stable,
  lib,
  myvars,
  ...
}: {
  home.packages = with pkgs; [
    xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
    xdg-user-dirs
  ];

  xdg = {
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
      defaultApplications = let
        terminal = ["kitty.desktop"];
        browser = ["firefox.desktop"];
        editor = [
          "nvim.desktop"
          "Helix.desktop"
          "code.desktop"
          "code-insiders.desktop"
        ];
        file-roller = ["org.gnome.FileRoller.desktop"];
        font-manager = ["com.github.FontManager.FontViewer.desktop"];
      in {
        "x-scheme-handler/ssh" = terminal;
        "x-scheme-handler/telnet" = terminal;
        "x-scheme-handler/x-man-page" = terminal;
        "TerminalEmulator" = terminal;

        "application/json" = browser;
        "application/pdf" = browser; # TODO: pdf viewer

        "text/html" = browser;
        "text/xml" = browser;
        "text/plain" = editor;
        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-wine-extension-ini" = editor;

        # define default applications for some url schemes.
        "x-scheme-handler/about" = browser; # open `about:` url with `browser`
        "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        # https://github.com/microsoft/vscode/issues/146408
        "x-scheme-handler/vscode" = [
          "code-url-handler.desktop"
        ]; # open `vscode://` url with `code-url-handler.desktop`
        "x-scheme-handler/vscode-insiders" = [
          "code-insiders-url-handler.desktop"
        ]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`
        # all other unknown schemes will be opened by this default application.
        # "x-scheme-handler/unknown" = editor;

        "audio/*" = ["mpv.desktop"];
        "video/*" = ["mpv.desktop"];
        "image/*" = ["imv-dir.desktop"];
        "image/gif" = ["imv-dir.desktop"];
        "image/jpeg" = ["imv-dir.desktop"];
        "image/png" = ["imv-dir.desktop"];
        "image/webp" = ["imv-dir.desktop"];

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

        "font/ttf" = font-manager;
        "font/ttc" = font-manager;
        "font/otf" = font-manager;
        "font/sfnt" = font-manager;
        "application/x-font-ttf" = font-manager;
        "application/x-font-otf" = font-manager;
        "application/vnd.ms-opentype" = font-manager;
      };

      associations.removed = {
        # ......
      };
    };
  };
  xdg.portal = {
    enable = true;

    config = rec {
      common = {
        # Use xdg-desktop-portal-gtk for every portal interface...
        default = ["gtk"];
        # except for the secret portal, which is handled by gnome-keyring
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
      gnome = lib.mkIf (myvars.desktop.gnome) {
        default = ["gnome"] ++ common.default;
      };
      hyprland = lib.mkIf (myvars.desktop.hyprland) {
        default = ["hyprland"] ++ common.default;
      };
      niri = lib.mkIf (myvars.desktop.niri) {
        default = ["gnome"] ++ common.default;
      };
      kde = lib.mkIf (myvars.desktop.kde) {
        default = ["kde"] ++ common.default;
      };
    };

    # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
    # This will make xdg-open use the portal to open programs,
    # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
    # xdg-open is used by almost all programs to open a unknown file/uri
    # alacritty as an example, it use xdg-open as default, but you can also custom this behavior
    # and vscode has open like `External Uri Openers`
    xdgOpenUsePortal = true;
    configPackages = with pkgs;
      []
      ++ lib.optionals (myvars.desktop.hyprland) [
        hyprland
      ]
      ++ lib.optionals (myvars.desktop.niri) [
        niri-unstable
      ];
    extraPortals = with pkgs;
      [
        xdg-desktop-portal
      ]
      ++ lib.optionals (myvars.desktop.gnome) [xdg-desktop-portal-gnome]
      ++ lib.optionals (myvars.desktop.kde) [kdePackages.xdg-desktop-portal-kde]
      ++ lib.optionals (myvars.desktop.hyprland) [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ]
      ++ lib.optionals (myvars.desktop.niri) [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
  };
}

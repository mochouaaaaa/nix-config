{ self, ... }: {
  flake.modules.homeManager."desktop.default-apps" =
    { pkgs, ... }:
    let
      documentViewers = [
        pkgs.evince
      ];

      archiveManagers = [
        pkgs.file-roller
      ];

    in
    {
      home.packages = documentViewers ++ archiveManagers;

      xdg.mimeApps = {
        # Use explicit desktop-file IDs so desktop environments do not have
        # to guess between every application that advertises a MIME type.
        defaultApplications = {
          # Web browser
          "text/html" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop";

          # Documents and images
          "application/pdf" = "org.gnome.Evince.desktop";
          "image/*" = "imv.desktop";

          # Media
          "audio/*" = "mpv.desktop";
          "video/*" = "mpv.desktop";
          "application/ogg" = "mpv.desktop";
          "application/x-ogg" = "mpv.desktop";

          # Archives
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
          "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
          "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";
          "application/gzip" = "org.gnome.FileRoller.desktop";
          "application/x-bzip" = "org.gnome.FileRoller.desktop";
          "application/x-xz" = "org.gnome.FileRoller.desktop";
          "application/x-rar" = "org.gnome.FileRoller.desktop";
          "application/vnd.rar" = "org.gnome.FileRoller.desktop";

          # Email and directories
          "x-scheme-handler/mailto" = "thunderbird.desktop";
          "inode/directory" = "org.gnome.Nautilus.desktop";
        };

        # Keep the package-derived associations as fallbacks. Program modules
        # contribute Firefox, Thunderbird, MPV and imv to this list.
        defaultApplicationPackages = documentViewers ++ archiveManagers;
      };
    };

  flake.modules.homeManager."desktop.hyprland" = {
    imports = [
      self.modules.homeManager."desktop.default-apps"
    ];
  };

  flake.modules.homeManager."desktop.niri" = {
    imports = [
      self.modules.homeManager."desktop.default-apps"
    ];
  };

  flake.modules.homeManager."desktop.gnome" = {
    imports = [
      self.modules.homeManager."desktop.default-apps"
    ];
  };

  flake.modules.homeManager."desktop.kde" = {
    imports = [
      self.modules.homeManager."desktop.default-apps"
    ];
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.packages = with pkgs; [
      # GUI apps
      # e-book viewer(.epub/.mobi/...)
      # do not support .pdf
      foliate
    ];

    programs.joplin-desktop = {
      enable = true;
      general.editor = null;

      sync = {
        # one of "undefined", "disabled", "5m", "10m", "30m", "1h", "12h", "1d"
        interval = "disabled";
        # one of "undefined", "none", "file-system", "onedrive", "nextcloud", "webdav", "dropbox", "s3", "joplin-server", "joplin-cloud"
        target = "none";
      };
    };

  };
}

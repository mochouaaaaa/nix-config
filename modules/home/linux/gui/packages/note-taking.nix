{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (!config.programs.wsl.enable) {

    home.packages = with pkgs; [
      # GUI apps
      # e-book viewer(.epub/.mobi/...)
      # do not support .pdf
      foliate
    ];

    programs.joplin-desktop = {
      enable = false;
      general.editor = null;

      sync = {
        # one of "undefined", "disabled", "5m", "10m", "30m", "1h", "12h", "1d"
        interval = null;
        # one of "undefined", "none", "file-system", "onedrive", "nextcloud", "webdav", "dropbox", "s3", "joplin-server", "joplin-cloud"
        target = null;
      };
    };

  };
}

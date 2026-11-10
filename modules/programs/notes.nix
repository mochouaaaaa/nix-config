{
  flake.modules.homeManager."desktop.common" = { pkgs, ... }: {

    home.packages = with pkgs; [
      # GUI apps
      # do not support .pdf
      foliate
    ];

    programs.joplin-desktop = {
      enable = true;
      settings = {
        # "editor" 也可以在这里用点号键名设置，但你不设置就是 null（自动检测）
        editor = null;

        # one of "undefined", "none", "file-system", "onedrive", "nextcloud", "webdav", "dropbox", "s3", "joplin-server", "joplin-cloud"
        "sync.target" = 0; # 0 = 禁用同步
        # one of "undefined", "disabled", "5m", "10m", "30m", "1h", "12h", "1d"
        "sync.interval" = 0; # 0 = 禁用自动同步
      };
    };

  };
}

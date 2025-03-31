{config, ...}: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  xdg.configFile = {
    "yazi" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/yazi";
    };
  };
}

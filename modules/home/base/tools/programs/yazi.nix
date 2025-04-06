{ config, ... }:
{
  programs.yazi = {
    enable = true;
  };

  xdg.configFile = {
    "yazi" = {
      force = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/yazi";
    };
  };
}

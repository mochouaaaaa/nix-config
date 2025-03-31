{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
  };

  xdg.configFile = {
    "zsh" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/zsh";
    };
  };
}

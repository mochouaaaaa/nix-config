{config, ...}: let
  # 获取 links 目录中的所有文件名
  linkFiles =
    builtins.filter (f: builtins.match ".*\\..*" f == null)
    (builtins.attrNames (builtins.readDir (config.dotfiles + "/zsh/links")));

  homeDotfiles = builtins.listToAttrs (map (linkFile: {
      name = "." + linkFile;
      value = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          (config.dotfiles + "/zsh/links/" + linkFile);
      };
    })
    linkFiles);
in {
  home.file = homeDotfiles;
}

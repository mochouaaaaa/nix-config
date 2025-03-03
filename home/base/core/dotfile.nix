{
  lib,
  config,
  myvars,
  ...
}: let
  filtereg =
    builtins.filter (f:
      !(builtins.substring 0 1 f == "." || builtins.match ".*\\..*" f != null));

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

  allFiles = builtins.readDir config.dotfiles;
  visibleFiles = filtereg (builtins.attrNames allFiles);

  configFiles = builtins.listToAttrs (map (linkFile: {
      name = "${linkFile}";
      value = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/${linkFile}";
      };
    })
    visibleFiles);
in {
  home.file = homeDotfiles;
  xdg.configFile = configFiles;
}

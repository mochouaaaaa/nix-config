{
  lib,
  config,
  myvars,
  ...
}:
{

  options.modules' = with lib; {

    dotfiles = mkOption {
      type = types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.config/${myvars.dotfilePath}";
    };

    dotfileLink = mkOption {
      # type = lib.types.defaultFunctor;
      default =
        folderName:
        builtins.listToAttrs (
          let
            dotfilesPath = "${config.modules'.dotfiles}/${folderName}";
            dirContentsNames = builtins.attrNames (builtins.readDir dotfilesPath);
          in
          map (fileName: {
            name = "${folderName}/${fileName}";
            value = {
              force = true;
              source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${fileName}";
            };
          }) dirContentsNames
        );
    };

  };

}

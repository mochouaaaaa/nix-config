{
  lib,
  config,
  myvars,
  inputs,
  ...
}:
{

  options.modules' = with lib; {

    dotfiles = mkOption {
      type = types.path;
      apply = toString;
      default =
        let
          localPath = "${config.home.homeDirectory}/.config/${myvars.dotfilePath}";
        in
        if builtins.pathExists localPath then localPath else inputs.dotfiles;
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

{
  lib,
  config,
  myvars,
  inputs,
  ...
}:
{

  options.profiles = with lib; {

    dotfiles = mkOption {
      type = types.path;
      apply = toString;
      default =
        let
          localPath = "${config.xdg.configHome}/${myvars.dotfilePath}";
        in
        if builtins.pathExists localPath then localPath else inputs.dotfiles;
    };

    dotfileLink = mkOption {
      # type = lib.types.defaultFunctor;
      default =
        folderName:
        builtins.listToAttrs (
          let
            dotfilesPath = "${config.profiles.dotfiles}/${folderName}";
            dirContentsNames = builtins.attrNames (builtins.readDir dotfilesPath);
          in
          map (fileName: {
            name = "${folderName}/${fileName}";
            value = {
              force = true;
              source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${fileName}");
            };
          }) dirContentsNames
        );
    };

  };

}

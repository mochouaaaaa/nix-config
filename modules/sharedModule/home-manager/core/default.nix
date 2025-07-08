{
  lib,
  config,
  isLinux,
  myvars,
  ...
}:
{
  imports = lib.importModule' ./.;

  options = {
    dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.config/${myvars.dotfilePath}";
      description = "Location of the dotfiles working copy";
    };
    dotfileLink = lib.mkOption {
      # type = lib.types.defaultFunctor;
      default =
        folderName:
        builtins.listToAttrs (
          let
            dotfilesPath = "${config.dotfiles}/${folderName}";
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

    keymaps.Super = lib.mkOption {
      type = lib.types.str;
      default = "cmd";
      description = "The key used for the super key.";
    };
  };

  config = lib.mkIf isLinux {
    targets.genericLinux.enable = true;
  };
}

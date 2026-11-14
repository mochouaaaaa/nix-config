{ inputs, ... }: {
  flake.modules.homeManager.core =
    {
      lib,
      config,
      myvars,
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
          default =
            folderName:
            let
              dotfilesPath = "${config.profiles.dotfiles}/${folderName}";
            in
            lib.mapAttrs' (
              fileName: _:
              lib.nameValuePair "${folderName}/${fileName}" {
                force = true;
                source = lib.mkForce (
                  config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${fileName}"
                );
              }
            ) (builtins.readDir dotfilesPath);
        };

      };

    };
}

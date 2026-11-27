{ inputs, ... }:
{
  flake.aspects."core"."homeManager" =
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
              localPath = "${config.profiles.dotfiles}/${folderName}";
              inputPath = "${inputs.dotfiles}/${folderName}";
              dotfilesPath = if builtins.pathExists localPath then localPath else inputPath;
              isStorePath = lib.hasPrefix "${builtins.storeDir}/" dotfilesPath;
            in
            lib.mapAttrs' (
              fileName: _:
              lib.nameValuePair "${folderName}/${fileName}" {
                force = true;
                source = lib.mkForce (
                  if isStorePath then
                    "${dotfilesPath}/${fileName}"
                  else
                    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${fileName}"
                );
              }
            ) (builtins.readDir dotfilesPath);
        };
      };
    };
}

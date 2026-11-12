{
  flake.modules.nixos.core =
    {
      self,
      inputs,
      lib,
      username,
      myvars,
      homeManagerNixpkgsInput,
      ...
    }:
    {
      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = false;

        # Use the host-selected nixpkgs source for Home Manager's private pkgs.
        sharedModules = [
          {
            _module.args.pkgsPath = lib.mkForce inputs.${homeManagerNixpkgsInput}.outPath;
          }
        ];

        backupFileExtension = "home-manager.backup";
        overwriteBackup = true;

        users.${username} = {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
          };
        };

        extraSpecialArgs = {
          inherit
            inputs
            self
            username
            hostName
            myvars
            homeManagerNixpkgsInput
            ;
        };
      };
    };
}

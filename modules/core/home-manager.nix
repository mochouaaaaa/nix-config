{
  flake.modules.nixos.core = {
    self, inputs, lib, platform, username, myvars, homeManagerNixpkgsInput, ...
  }: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = false;
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
        inherit inputs self username platform myvars homeManagerNixpkgsInput;
      };
    };
  };
}

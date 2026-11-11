{
  flake.modules.nixos.core =
    {
      self,
      inputs,

      platform,
      username,
      myvars,
      ...
    }:
    {
      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = false;

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
            platform

            myvars
            ;

        };

      };
    };
}

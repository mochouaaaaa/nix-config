{
  flake.modules.nixos.core =
    {
      self,
      inputs,
      username,
      hostName,
      myvars,
      ...
    }:
    {
      home-manager = {
        # Home Manager shares the system package set; its version is selected
        # independently through the host's "home-manager" flake input.
        useGlobalPkgs = true;
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
          inherit inputs self username hostName myvars;
        };
      };
    };
}

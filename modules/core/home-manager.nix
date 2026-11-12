let
  homeManagerIntegration = {
    home-manager = {
      backupFileExtension = "home-manager.backup";
      overwriteBackup = true;
    };
  };
in
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
      imports = [ homeManagerIntegration ];

      home-manager = {
        # Home Manager shares the system package set; its version is selected
        # independently through the host's "home-manager" flake input.
        useGlobalPkgs = true;
        useUserPackages = false;

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

  flake.modules.homeManager.host = { self, ... }: {
    imports = [
      self.modules.homeManager.agenix
      self.modules.homeManager.core
      self.modules.homeManager.programs
      self.modules.homeManager.workstation
    ];
  };
}

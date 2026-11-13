let
  homeManagerIntegration = {
    home-manager = {
      backupFileExtension = "home-manager.backup";
      overwriteBackup = true;
    };
  };
in
{
  flake.modules.nixos.home-manager-backup = homeManagerIntegration;
  flake.modules.darwin.home-manager-backup = homeManagerIntegration;

  flake.modules.nixos.core =
    {
      self,
      inputs,
      username,
      hostName,
      class,
      myvars,
      ...
    }:
    {
      imports = [ self.modules.nixos.home-manager-backup ];

      home-manager = {
        # Keep the package-set integration policy here. Host input selection
        # remains the responsibility of hosts/<host>/nixpkgs.json.
        useGlobalPkgs = true;
        useUserPackages = false;

        users.${username}.home = {
          inherit username;
          homeDirectory = "/home/${username}";
        };

        extraSpecialArgs = {
          inherit
            inputs
            self
            username
            hostName
            class
            myvars
            ;
        };
      };
    };

  flake.modules.homeManager.host = { self, ... }: {
    imports = [
      self.modules.homeManager.agenix
      self.modules.homeManager.core
      self.modules.homeManager."appearance.font-options"
      self.modules.homeManager."programs.kitty-options"
      self.modules.homeManager.programs
    ];
  };
}

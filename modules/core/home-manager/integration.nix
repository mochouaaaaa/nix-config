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
      lib,
      pkgs,

      username,
      homeManagerNixpkgsInput,
      hostName,
      class,
      myvars,
      ...
    }:
    {
      imports = [ self.modules.nixos.home-manager-backup ];

      home-manager = {
        # An explicit Home Manager nixpkgs input selects a private package set.
        # Otherwise, reuse the system package set.
        useGlobalPkgs = homeManagerNixpkgsInput == null;
        useUserPackages = true;

        sharedModules = lib.optional (homeManagerNixpkgsInput != null) {
          _module.args.pkgsPath = inputs.${homeManagerNixpkgsInput}.outPath;
        };

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

          pkgsStable = import inputs.nixpkgs-stable {
            inherit (pkgs.stdenv.hostPlatform) system;
            config.allowUnfree = true;
          };

        };
      };
    };

  # Shared Home Manager foundations only. Select a role explicitly in each host.
  flake.modules.homeManager.host = { self, ... }: {
    imports = [
      self.modules.homeManager.core
      self.modules.homeManager."system.ssh"
    ];
  };
}

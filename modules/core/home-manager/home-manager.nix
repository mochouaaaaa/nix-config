{
  flake.modules.generic.home-manager =
    {
      homeManagerNixpkgsInput,
      ...
    }:
    {

      home-manager = {
        backupFileExtension = "home-manager.backup";
        overwriteBackup = true;

        # An explicit Home Manager nixpkgs input selects a private package set.
        # Otherwise, reuse the system package set.
        useGlobalPkgs = homeManagerNixpkgsInput == null;
        useUserPackages = true;
      };

    };

  flake.modules.nixos.core =
    {
      self,
      inputs,
      pkgs,
      ...
    }:
    {

      imports = [ self.modules.generic.home-manager ];

      home-manager = {
        extraSpecialArgs = {
          pkgsStable = import inputs.nixpkgs-stable {
            inherit (pkgs.stdenv.hostPlatform) system;
            config.allowUnfree = true;
          };
        };

      };

    };

  flake.modules.darwin.core = { self, ... }: {
    imports = [ self.modules.generic.home-manager ];

  };

  flake.modules.homeManager.core =
    {
      lib,
      inputs,
      homeManagerNixpkgsInput,
      ...
    }:
    {
      systemd.user.startServices = "sd-switch";
      home = {
        enableNixpkgsReleaseCheck = false;
        backupFileExtension = "home-manager.backup";
        overwriteBackup = true;
      };

      _module.args = lib.optionalAttrs (homeManagerNixpkgsInput != null) {
        pkgsPath = inputs.${homeManagerNixpkgsInput}.outPath;
      };

    };

  flake.modules.homeManager.linux = { username, ... }: {
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
    };
  };

  flake.modules.homeManager.darwin = { username, ... }: {
    home = {
      inherit username;
      homeDirectory = "/Users/${username}";
    };
  };

  # Shared Home Manager foundations only. Select a role explicitly in each host.
  flake.modules.homeManager.host = { self, ... }: {
    imports = [
      self.modules.homeManager.core
    ];
  };

}

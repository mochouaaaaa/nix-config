{
  flake.aspects."home-manager"."generic" =
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

  flake.aspects."core"."nixos" =
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

  flake.aspects."core"."darwin" = { self, ... }: {
    imports = [ self.modules.generic.home-manager ];
  };

  flake.aspects."core"."homeManager" =
    { lib, config, ... }:
    let
      hasBackHM = lib.hasAttrByPath [ "home" "backupFileExtension" ] config;
    in
    {
      systemd.user.startServices = "sd-switch";
      home = {
        enableNixpkgsReleaseCheck = false;
      }
      // lib.optionalAttrs hasBackHM {
        backupFileExtension = "home-manager.backup";
        overwriteBackup = true;
      };
    };

  # Shared Home Manager foundations only. Select a role explicitly in each host.
  flake.aspects."host"."homeManager" = { self, ... }: {
    imports = [
      self.modules.homeManager.core
    ];
  };

}

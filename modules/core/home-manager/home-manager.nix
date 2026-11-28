{ inputs, ... }:
{
  flake.aspects = { aspects, ... }: {
    "core".includes = [
      (inputs.flake-aspects.lib.forward {
        each = [ null ];
        fromClass = _: "generic";
        intoClass = _: "nixos";
        intoPath = _: [ ];
        fromAspect = _: aspects."home-manager";
      })
      (inputs.flake-aspects.lib.forward {
        each = [ null ];
        fromClass = _: "generic";
        intoClass = _: "darwin";
        intoPath = _: [ ];
        fromAspect = _: aspects."home-manager";
      })
    ];

    "home-manager".generic =
      { homeManagerNixpkgsInput, ... }:
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

    "core".nixos =
      { inputs, pkgs, ... }:
      {
        home-manager.extraSpecialArgs = {
          pkgsStable = import inputs.nixpkgs-stable {
            inherit (pkgs.stdenv.hostPlatform) system;
            config.allowUnfree = true;
          };
        };
      };

    "core".darwin = { ... }: { };

    "core".homeManager =
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
    "host" = {
      includes = [ aspects.core ];
      homeManager = { ... }: { };
    };
  };
}

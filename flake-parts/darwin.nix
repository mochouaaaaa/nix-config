{
  config,
  self,
  lib,
  inputs,
  withSystem,
  ...
}:

let
  inherit lib;
  inherit (lib) types;

  darwinOpts =
    opts@{ config, name, ... }:
    {
      options = {
        system = lib.mkOption {
          type = types.enum [
            "aarch64-darwin"
            "x86_64-darwin"
          ];
          description = "System architecture for the configuration.";
        };

        stateVersion = lib.mkOption {
          type = types.int;
          description = "nix-darwin state version, changing this value DOES NOT update your system.";
        };

        modules = lib.mkOption rec {
          type = types.listOf types.unspecified;
          description = "List of nix-darwin modules to include in the configuration.";
          default = [
            self.darwinModules.shared
            self.darwinModules.secrets
          ];
          apply = userValue: default ++ userValue;

        };

        homeModules = lib.mkOption rec {
          type = types.listOf types.unspecified;
          default = [ ];
          description = "List of home-manager modules to disable.";
          apply = userValue: default ++ userValue;
        };

        _darwin = lib.mkOption {
          type = types.unspecified;
          readOnly = true;
          description = "Composed nix-darwin configuration.";
        };
      };

      config._darwin = withSystem config.system (
        ctx:
        let
          inherit (inputs) nix-darwin home-manager;

          splitName = __elemAt (lib.strings.split "@" name);
          hostname = splitName 2; # nixos
          username = splitName 0; # mochou

          specialArgs = ctx.extraModuleArgs // {
            inherit (ctx) lib;
            inherit hostname username;
            pkgs-unstable = ctx.pkgs-unstable;
          };

        in
        nix-darwin.lib.darwinSystem {

          inherit specialArgs;
          inherit (ctx) system;

          modules =
            config.modules

            ++ (lib.optionals ((lib.lists.length config.homeModules) > 0) [
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "home-manager.backup";
                home-manager.sharedModules = [
                  self.homeModules.shared
                ];

                home-manager.extraSpecialArgs = specialArgs // {
                  pkgs = ctx.extraModuleArgs.mkPkgs inputs.nixpkgs {
                    overlays = [ self.overlays.home-manager ];
                  };
                  pkgs-stable = ctx.extraModuleArgs.pkgs-os;
                  isNixos = false;
                  nixosSystemName = "${username}@nixos";
                  isNixDarwin = true;
                  nixDarwinSystemName = name;
                  homeManagerName = name;
                };
                home-manager.users."${username}" = {
                  imports = config.homeModules;
                  nix = (
                    removeAttrs ctx.nix [
                      "channel"
                      "gc"
                    ]
                  );
                  home = {
                    enableNixpkgsReleaseCheck = false;
                    inherit username;
                    stateVersion = "24.11";
                    homeDirectory = "/Users/${username}";
                  };
                };
              }
            ])

            ++ [
              {
                inherit (ctx) nix;

                nixpkgs = lib.mkMerge [
                  {
                    overlays = [
                      self.overlays.darwin
                    ];
                  }
                  ctx.nixpkgs
                ];

                networking.hostName = hostname;
                system.defaults.smb.NetBIOSName = hostname;
                system.stateVersion = config.stateVersion;
              }
            ];
        }
      );
    };
in
{
  options.flake-parts.darwinConfigurations = lib.mkOption {
    type = types.attrsOf (types.submodule darwinOpts);
  };

  config.flake.darwinConfigurations = __mapAttrs (
    _: value: value._darwin
  ) config.flake-parts.darwinConfigurations;
}

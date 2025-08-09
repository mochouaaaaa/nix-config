{
  config,
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  inherit lib;
  inherit (lib) types;

  nixosOpts =
    opts@{ config, name, ... }:
    {
      options = {

        system = lib.mkOption {
          type = types.enum [
            "aarch64-linux"
            "x86_64-linux"
          ];
          description = "System architecture for the configuration.";
        };

        stateVersion = lib.mkOption {
          type = types.str;
          description = "NixOS state version, changing this value DOES NOT update your system.";
        };

        modules = lib.mkOption rec {
          type = types.listOf types.unspecified;
          description = "List of NixOS modules to include in the configuration.";
          default = [
            self.sharedModules.os

            {
              nixpkgs.overlays = [
                self.overlays.nixos
              ];
            }
          ];
          apply = userValue: default ++ userValue;
        };

        homeModules = lib.mkOption rec {
          type = types.listOf types.unspecified;
          default = [
            self.sharedModules.home-manager
          ];
          description = "List of home-manager modules to disable.";
          apply = userValue: default ++ userValue;

        };

        _nixos = lib.mkOption {
          type = types.unspecified;
          readOnly = true;
          description = "Composed NixOS configuration.";
        };

      };

      config._nixos = withSystem "${config.system}" (
        ctx:
        let
          inherit (inputs) home-manager nixos-generators;

          splitName = __elemAt (lib.strings.split "@" name);
          hostname = splitName 2; # nixos
          username = splitName 0; # mochou

          specialArgs =
            ctx.extraModuleArgs
            // {
              inherit self;
              inherit (ctx) lib;
              inherit hostname username;
            }
            // {
              pkgs-unstable = ctx.extraPackages.pkgs-unstable;
            };

        in
        inputs.nixpkgs-os.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            nixos-generators.nixosModules.all-formats
          ]
          ++ config.modules

          ++ (lib.optionals ((lib.lists.length config.homeModules) > 0) [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = false;
              home-manager.backupFileExtension = "home-manager.backup";

              home-manager.extraSpecialArgs = specialArgs // {

                pkgs = ctx.extraPackages.mkPkgs inputs.nixpkgs-unstable {
                  overlays = [ self.overlays.home-manager ];
                };
                pkgs-stable = ctx.extraPackages.pkgs-stable;

                isNixos = true;
                nixosSystemName = name;
                isNixDarwin = false;
                nixDarwinSystemName = "${username}@darwin";
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
                  inherit (opts.config) stateVersion;
                };
              };
            }
          ])

          ++ [
            (
              { pkgs, ... }:
              {
                inherit (ctx)
                  nix
                  nixpkgs
                  ;
                _module.args = ctx.extraModuleArgs;
                networking.hostName = hostname;

                system = {
                  stateVersion = config.stateVersion;
                  rebuild.enableNg = true;
                };

                environment = {
                  enableAllTerminfo = false;
                };
              }
            )
          ];
        }
      );
    };

in
{

  options.flake-parts.nixosConfigurations = lib.mkOption {
    type = types.attrsOf (types.submodule nixosOpts);
  };

  config.flake.nixosConfigurations = __mapAttrs (
    _: value: value._nixos
  ) config.flake-parts.nixosConfigurations;
}

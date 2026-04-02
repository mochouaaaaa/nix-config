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
          default = [ ];
          apply = userValue: default ++ userValue;
        };

        homeModules = lib.mkOption rec {
          type = types.listOf types.unspecified;
          default = [ ];
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

          specialArgs = ctx.extraModuleArgs // {
            inherit (ctx) lib profiles;
            inherit hostname username;

            isNixos = true;
            isNixDarwin = false;
          };

        in
        inputs.nixpkgs-stable.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            nixos-generators.nixosModules.all-formats
          ]
          ++ config.modules

          ++ (lib.optionals ((lib.lists.length config.homeModules) > 0) [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = false;
                backupFileExtension = "home-manager.backup";
                overwriteBackup = true;
                sharedModules = [
                  self.homeModules.default
                ];

                extraSpecialArgs = specialArgs // {

                  pkgs = ctx.extraModuleArgs.mkPkgs inputs.nixpkgs {
                    overlays = [ self.overlays.home-manager ];
                  };
                  pkgs-stable = ctx.extraModuleArgs.pkgs-stable;
                  nixosSystemName = name;
                  nixDarwinSystemName = "${username}@darwin";
                  homeManagerName = name;
                };

                users."${username}" = {
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
                    homeDirectory = "/home/${username}";
                  };
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
                    self.overlays.nixos
                  ];
                }
                ctx.nixpkgs
              ];

              networking.hostName = hostname;

              system = {
                stateVersion = config.stateVersion;
              };

            }
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

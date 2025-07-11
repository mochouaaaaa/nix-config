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
            {
              nixpkgs.overlays = [
                self.overlays.nixos
              ];
            }
          ];
          apply = userValue: default ++ userValue;
        };

        homeModules = lib.mkOption {
          type = types.listOf types.attrs;
          default = [ ];
          description = "List of home-manager modules to disable.";
        };

        nixosDisables = lib.mkOption {
          type = types.listOf types.attrs;
          default = [ ];
          description = "List of NixOS modules to disable.";
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

          specialArgs =
            ctx.extraModuleArgs
            // {
              inherit (ctx) lib;
            }
            // {
              isNixos = true;
              nixosSystemName = name;
            };

        in
        inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules =
            [ nixos-generators.nixosModules.all-formats ]
            ++ config.modules
            ++ [
              # Shared configuration across all NixOS machines
              self.sharedModules.os
            ]
            ++ config.nixosDisables
            ++ (lib.optionals ((lib.lists.length config.homeModules) > 0) [
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "home-manager.backup";

                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users."${name}".imports = config.homeModules;
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
                  networking.hostName = name;

                  system = {
                    stateVersion = config.stateVersion;
                    rebuild.enableNg = true;
                  };

                  environment = {
                    enableAllTerminfo = false;
                    # systemPackages = ctx.basePackagesFor pkgs;
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

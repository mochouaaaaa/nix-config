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
    { config, name, ... }:
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
            self.sharedModules.os

            {
              nixpkgs.overlays = [
                self.overlays.darwin
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

        darwinDisables = lib.mkOption {
          type = types.listOf types.attrs;
          default = [ ];
          description = "List of NixOS modules to disable.";
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

          specialArgs =
            ctx.extraModuleArgs
            // {
              inherit (ctx) lib;
              inherit hostname username;
            }
            // {
              isNixDarwin = true;
              nix-darwinSystemName = name;
            };

        in
        nix-darwin.lib.darwinSystem {

          inherit specialArgs;
          inherit inputs self;
          inherit (ctx) system;

          modules =
            config.modules
            ++ config.darwinDisables

            ++ (lib.optionals ((lib.lists.length config.homeModules) > 0) [
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "home-manager.backup";

                home-manager.extraSpecialArgs = specialArgs // {
                  isNixos = false;
                  nixosSystemName = "";
                  isNixDarwin = true;
                  nixDarwinSystemName = name;
                  homeManagerName = name;
                };
                home-manager.users."${username}".imports = config.homeModules;
              }
            ])

            ++ [
              (
                { pkgs, ... }:
                {
                  inherit (ctx) nix nixpkgs;
                  networking.hostName = hostname;
                  system.defaults.smb.NetBIOSName = hostname;
                  system.stateVersion = config.stateVersion;
                }
              )
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

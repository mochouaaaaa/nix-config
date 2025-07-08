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
            {
              nixpkgs.overlays = [
                self.overlays.darwin
              ];
            }
          ];
          apply = userValue: default ++ userValue;

        };

        homeDisables = lib.mkOption {
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
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = ctx.extraModuleArgs // {
            inherit (ctx) lib;
          };

          inherit inputs;
          inherit (ctx) system;

          modules =
            config.modules
            ++ config.darwinDisables
            ++ config.homeDisables
            ++ [
              self.sharedModules.os
            ]
            ++ [
              (
                { pkgs, ... }:
                {
                  inherit (ctx) nix;
                  networking.hostName = name;
                  system.defaults.smb.NetBIOSName = name;
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

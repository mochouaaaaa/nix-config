{
  self,
  config,
  lib,
  inputs,
  withSystem,
  ...
}:

let
  inherit lib;
  inherit (lib) types;

  homeOpts =
    opts@{
      config,
      lib,
      name,
      ...
    }:
    {
      options = {
        system = lib.mkOption {
          type = types.enum [
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-darwin"
            "x86_64-linux"
          ];

          description = "System architecture for the configuration.";
        };

        stateVersion = lib.mkOption {
          type = types.str;
          description = "home-manager state version, changing this value DOES NOT update your config.";
        };

        modules = lib.mkOption rec {
          type = types.listOf types.unspecified;
          description = "List of home-manager modules to include in the configuration.";
          default = [
            self.sharedModules.home-manager
          ];
          apply = userValue: default ++ userValue;

        };

        _home = lib.mkOption {
          type = types.unspecified;
          readOnly = true;
          description = "Composed home-manager configuration.";
        };
      };

      config._home = withSystem config.system (
        ctx:
        let
          overlays = [ self.overlays.home-manager ];
          custom_config = {
            allowUnfree = true;
            allowBroken = true;
            allowUnsupportedSystem = true;
            permittedInsecurePackages = [
              "openssl-1.1.1w"
              "ventoy-1.1.05"
            ];
          };

          splitName = __elemAt (lib.strings.split "@" name);
          hostname = splitName 2;
          username = splitName 0;

        in
        inputs.home-manager.lib.homeManagerConfiguration {

          pkgs = ctx.extraPackages.mkPkgs inputs.nixpkgs-unstable {
            inherit overlays custom_config;
          };

          extraSpecialArgs =
            let
              pkgs-stable = ctx.extraPackages.mkPkgs inputs.nixpkgs-stable {
                inherit overlays custom_config;
              };
            in
            ctx.extraModuleArgs
            // {
              inherit self;
              inherit (ctx) lib;
              inherit pkgs-stable;
            }
            // {
              inherit hostname username;
              homeManagerName = name;
              # 以下参数是给nixos/nix-darwin 分开使用home-manager时参数兼容
              isNixDarwin = false;
              isNixos = false;
              nixDarwinSystemName = "";
              nixosSystemName = "";
            };

          modules = config.modules ++ [
            (
              {
                config,
                lib,
                pkgs,
                ...
              }:
              {

                nix =
                  (removeAttrs ctx.nix [
                    "channel"
                    "gc"
                  ])
                  // {
                    package = pkgs.nix;
                  };

                home = {
                  username = username;
                  enableNixpkgsReleaseCheck = false;
                  inherit (opts.config) stateVersion;

                  homeDirectory = lib.mkMerge [
                    (lib.mkIf pkgs.stdenv.isDarwin "/Users/${config.home.username}")
                    (lib.mkIf pkgs.stdenv.isLinux "/home/${config.home.username}")
                  ];
                };
              }
            )
          ];
        }
      );
    };
in
{
  options.flake-parts.homeConfigurations = lib.mkOption {
    type = types.attrsOf (types.submodule homeOpts);
  };

  config.flake.homeConfigurations = __mapAttrs (
    _: value: value._home
  ) config.flake-parts.homeConfigurations;
}

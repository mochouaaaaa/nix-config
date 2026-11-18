{
  config,
  inputs,
  lib,
  registry,
  self,
}:

let
  # Keep the fast metadata-only check independent from system evaluation.
  checkOnly = builtins.getEnv "NIX_CONFIG_CHECK" == "1";

  hostArgs = host: {
    inherit inputs self;
    inherit (host)
      username
      hostName
      system
      osInput
      class
      homeManagerNixpkgsInput
      ;
    inherit (config) myvars;
  };

  nixosConfigurations = lib.optionalAttrs (!checkOnly) (
    lib.mapAttrs (
      _name: host:
      inputs.${host.osInput}.lib.nixosSystem {
        specialArgs = hostArgs host;

        modules = [
          inputs.${host.homeManagerInput}.nixosModules.home-manager
          self.modules.nixos.core
          self.modules.nixos."services.base"
        ]
        ++ lib.optional host.nixosWsl host.nixosWslModule
        ++ [ (inputs.import-tree host.path) ];
      }
    ) registry.nixosHosts
  );

  darwinConfigurations = lib.optionalAttrs (!checkOnly) (
    lib.mapAttrs (
      _name: host:
      inputs.${host.osInput}.lib.darwinSystem {
        specialArgs = hostArgs host;

        modules = [
          (_: {
            nixpkgs.hostPlatform = host.system;
          })
          inputs.${host.homeManagerInput}.darwinModules.home-manager
          self.modules.darwin.core
          self.modules.darwin.env
          self.modules.darwin."system.defaults"
          self.modules.darwin.security
          self.modules.darwin.homebrew
          self.modules.darwin.services
          self.modules.darwin.home-manager
          (inputs.import-tree host.path)
        ];
      }
    ) registry.darwinHosts
  );

  homeConfigurations = lib.optionalAttrs (!checkOnly) (
    lib.mapAttrs (
      _name: host:
      inputs.${host.homeManagerInput}.lib.homeManagerConfiguration {
        pkgs = import inputs.${host.homeManagerNixpkgsInput} {
          inherit (host) system;
          config.allowUnfree = true;
          overlays = [ self.overlays.home-manager ];
        };

        extraSpecialArgs = hostArgs host;

        modules = [
          self.modules.homeManager.nix-settings
          (inputs.import-tree host.path)
          { programs.home-manager.enable = true; }
        ];
      }
    ) registry.homeHosts
  );
in
{
  inherit
    nixosConfigurations
    darwinConfigurations
    homeConfigurations
    ;
}

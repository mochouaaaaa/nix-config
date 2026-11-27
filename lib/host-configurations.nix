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

  desktopModules =
    host:
    if host.desktop == null then
      [ ]
    else
      let
        aspectsLib = inputs.flake-aspects.lib lib;

        forwardedDesktop = aspectsLib.forward {
          each = [ host.username ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = _: [
            "home-manager"
            "users"
            host.username
          ];
          fromAspect = _: {
            homeManager = self.modules.homeManager."desktop.${host.desktop}";
          };
        };
      in
      [
        self.modules.nixos."desktop.${host.desktop}"
        (aspectsLib.resolve "nixos" [ ] forwardedDesktop)
      ];

  nixosConfigurations = lib.optionalAttrs (!checkOnly) (
    lib.mapAttrs (
      _name: host:
      inputs.${host.osInput}.lib.nixosSystem {
        specialArgs = hostArgs host;

        modules = [
          inputs.${host.homeManagerInput}.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = hostArgs host;
          }
          self.modules.nixos.core
          self.modules.nixos."services.base"
        ]
        ++ lib.optional host.nixosWsl host.nixosWslModule
        ++ desktopModules host
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
          {
            home-manager.extraSpecialArgs = hostArgs host;
          }
          self.modules.darwin.core
          self.modules.darwin.env
          self.modules.darwin."system.defaults"
          self.modules.darwin.security
          self.modules.darwin.homebrew
          self.modules.darwin.services
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
          {
            programs.home-manager.enable = true;
            targets.genericLinux.enable = true;
          }
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

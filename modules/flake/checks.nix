{
  inputs,
  ...
}:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let
      # Force all declared hosts through module evaluation far enough to obtain
      # their top-level derivation paths, without building system closures.
      hostDerivations = {
        nixos = builtins.mapAttrs (_: host: host.config.system.build.toplevel.drvPath)
          inputs.self.nixosConfigurations;
        darwin = builtins.mapAttrs (_: host: host.config.system.build.toplevel.drvPath)
          inputs.self.darwinConfigurations;
        home = builtins.mapAttrs (_: home: home.activationPackage.drvPath)
          inputs.self.homeConfigurations;
      };
    in
    {
      checks = {
        # treefmt-nix registers its formatting check automatically.
        devshell = config.devShells.default;

        # Evaluates NixOS, nix-darwin and standalone Home Manager configurations.
        # --no-build evaluates this derivation but does not build host closures.
        host-evaluations = pkgs.writeText "host-evaluations.json" (builtins.toJSON hostDerivations);
      };
    };
}

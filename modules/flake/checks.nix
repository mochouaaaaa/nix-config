{
  inputs,
  ...
}:
{
  perSystem =
    {
      config,
      lib,
      pkgs,
      system,
      ...
    }:
    let
      checkOnly = builtins.getEnv "NIX_CONFIG_CHECK" == "1";

      # Validate only the lightweight host registry. Evaluating system toplevel
      # or Home Manager activation derivations would traverse host packages and
      # unnecessarily force evaluation of external package flakes.
      hostMetadata = inputs.self.lib.hostMetadata;
      checkedHostMetadata = builtins.deepSeq hostMetadata hostMetadata;

      hostsForSystem = lib.filterAttrs (
        _name: host:
        host.system == system
        && builtins.elem host.class [
          "nixos"
          "darwin"
        ]
      ) hostMetadata;

      homeHostsForSystem = lib.filterAttrs (
        _name: host: host.system == system && host.class == "home"
      ) hostMetadata;

      hostToplevelDrvPaths =
        if checkOnly then
          { }
        else
          lib.mapAttrs (
            name: host:
            let
              hostConfig =
                if host.class == "nixos" then
                  inputs.self.nixosConfigurations.${name}
                else
                  inputs.self.darwinConfigurations.${name};
            in
            builtins.addErrorContext "while evaluating ${host.class} host '${name}' toplevel" (
              builtins.unsafeDiscardStringContext hostConfig.config.system.build.toplevel.drvPath
            )
          ) hostsForSystem;

      homeActivationDrvPaths =
        if checkOnly then
          { }
        else
          lib.mapAttrs (
            name: _host:
            builtins.addErrorContext "while evaluating standalone Home Manager host '${name}' activation" (
              builtins.unsafeDiscardStringContext inputs.self.homeConfigurations.${name}.activationPackage.drvPath
            )
          ) homeHostsForSystem;
    in
    {
      checks = {
        # treefmt-nix registers its formatting check automatically.
        devshell = config.devShells.default;

        host-evaluations = pkgs.writeText "host-evaluations.json" (builtins.toJSON checkedHostMetadata);
      }
      // lib.optionalAttrs (!checkOnly && builtins.attrNames hostsForSystem != [ ]) {
        # Evaluating drvPath checks module options and assertions without building
        # the system closure. NIX_CONFIG_CHECK=1 keeps the metadata-only path fast.
        host-toplevels = pkgs.writeText "host-toplevels.json" (builtins.toJSON hostToplevelDrvPaths);
      }
      // lib.optionalAttrs (!checkOnly && builtins.attrNames homeHostsForSystem != [ ]) {
        home-activations = pkgs.writeText "home-activations.json" (builtins.toJSON homeActivationDrvPaths);
      };
    };
}

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
      # Validate only the lightweight host registry. Evaluating system toplevel
      # or Home Manager activation derivations would traverse host packages and
      # unnecessarily force evaluation of external package flakes.
      hostMetadata = inputs.self.lib.hostMetadata;
      checkedHostMetadata = builtins.deepSeq hostMetadata hostMetadata;
    in
    {
      checks = {
        # treefmt-nix registers its formatting check automatically.
        devshell = config.devShells.default;

        host-evaluations = pkgs.writeText "host-evaluations.json" (builtins.toJSON checkedHostMetadata);
      };
    };
}

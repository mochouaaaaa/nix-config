{

  flake.modules.nixos.assertions =
    { config, lib, ... }:
    let
      hasTmpfs = lib.any (fs: fs.fsType == "tmpfs") (lib.attrValues config.fileSystems);

      hasPreservationNode = lib.hasAttrByPath [ "preservation" "enable" ] config;
      hasPreservation = hasPreservationNode && config.preservation.enable;
    in
    {
      assertions = [
        {
          assertion = hasTmpfs == hasPreservation;

          message = ''
            NixOS filesystem and preservation configuration mismatch.

            Detected tmpfs: ${if hasTmpfs then "yes" else "no"}
            Preservation enabled: ${if hasPreservation then "yes" else "no"}

            Requirements:
              - If tmpfs exists, import self.modules.nixos.preservation.
              - If tmpfs does not exist, do not import self.modules.nixos.preservation.
          '';
        }
      ];
    };

  flake.modules.nixos.core = { self, ... }: {
    imports = [ self.modules.nixos.assertions ];
  };
}

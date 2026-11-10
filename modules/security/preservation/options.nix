{
  flake.modules.nixos.preservation =
    { lib, ... }:

    let
      inherit (lib) mkOption types;

    in
    {
      options.profiles.preservation = {
        enable = lib.mkEnableOption "preservation";
        storagePath = mkOption {
          type = lib.types.str;
          default = "/nix/persistence";
          description = "Persistent storage path used by preservation.";
        };

        directories = mkOption {
          type = lib.types.listOf (types.either types.str types.attrs);
          default = [ ];
          description = "System directories to preserve.";
        };

        files = mkOption {
          type = lib.types.listOf (types.either types.str types.attrs);
          default = [ ];
          description = "System files to preserve.";
        };

        users = mkOption {
          default = { };
          type = types.attrsOf (
            types.submodule {
              options = {
                directories = mkOption {
                  type = lib.types.listOf (types.either types.str types.attrs);
                  default = [ ];
                  description = "Home-relative directories to preserve.";
                };
                files = mkOption {
                  type = lib.types.listOf (types.either types.str types.attrs);
                  default = [ ];
                  description = "Home-relative files to preserve.";
                };
                commonMountOptions = mkOption {
                  type = lib.types.listOf types.str;
                  default = [ ];
                  description = "Common mount options for Home Manager preservation entries.";
                };
              };
            }
          );
          description = "Per-user state to preserve.";
        };

      };
    };
}

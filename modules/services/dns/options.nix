{
  flake.modules.nixos."services.dns" =
    { lib, pkgs, ... }:
    let
      formatYaml = pkgs.formats.yaml { };
    in
    {

      options.profiles.services.dns = {

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.mosdns;
        };

        listen = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1:5335";
          description = "The address and port to listen on.";
        };

        webapi = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1:8338";
        };

        settings = lib.mkOption {
          default = { };
          inherit (formatYaml) type;
        };

      };

    };
}

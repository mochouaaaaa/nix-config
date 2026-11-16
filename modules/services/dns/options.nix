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

        mihomoEnable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Mihomo DNS enable.";
        };
        # Optional integration point populated by the proxy module when both
        # services are part of the same NixOS configuration.
        mihomoSocksAddress = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          internal = true;
          description = "Mihomo SOCKS endpoint supplied by the optional proxy module.";
        };
        mihomoDNSListen = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Mihomo DNS listen address.";
        };

        settings = lib.mkOption {
          default = { };
          inherit (formatYaml) type;
        };

      };

    };
}

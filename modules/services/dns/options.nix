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

        proxyFallback = lib.mkOption {
          type = lib.types.enum [
            "direct"
            "reject"
          ];
          default = "direct";
          description = ''
            How to handle DNS upstreams that normally use Mihomo when Mihomo is disabled.
            - direct: connect to those upstreams directly.
            - reject: keep them routed through the unavailable Mihomo SOCKS endpoint.
            NextDNS is always direct and is not affected by this setting.
          '';
        };

        settings = lib.mkOption {
          default = { };
          inherit (formatYaml) type;
        };

      };

    };
}

{
  flake.modules.nixos."services.proxy" =
    { config, lib, ... }:
    let
      cfg = config.profiles.services.proxy;
    in
    {
      options.profiles.services.proxy = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Default enable switch for DAE and Mihomo.";
        };

        dae.enable = lib.mkOption {
          type = lib.types.bool;
          default = cfg.enable;
          description = "Whether to enable DAE. Requires Mihomo.";
        };

        mihomo = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = cfg.enable;
            description = "Whether to enable Mihomo.";
          };

          address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Mihomo address used by local proxy clients; keep it aligned with bind-address in mihomo.yaml.";
          };

          http.port = lib.mkOption {
            type = lib.types.port;
            default = 7890;
            description = "Mihomo HTTP proxy port.";
          };

          socks.port = lib.mkOption {
            type = lib.types.port;
            default = 7891;
            description = "Mihomo SOCKS proxy port.";
          };

          dns = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable Mihomo's built-in DNS server.";
            };

            listen = lib.mkOption {
              type = lib.types.str;
              default = ":53";
              description = "Mihomo DNS listen address.";
            };

            ipv6 = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether Mihomo DNS resolves IPv6 addresses.";
            };
          };
        };
      };

      config.assertions = [
        {
          assertion = !cfg.dae.enable || cfg.mihomo.enable;
          message = "profiles.services.proxy.dae.enable requires profiles.services.proxy.mihomo.enable.";
        }
      ];
    };
}

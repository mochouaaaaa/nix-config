{
  flake.aspects.services.provides.proxy.nixos =
    { config, lib, ... }:
    {
      options.profiles.services.proxy = {

        mihomo = {
          subscriptionEnvironmentFile = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional systemd EnvironmentFile containing Mihomo template variables such as subscription.";
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
            listen = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = 1053;
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
          assertion = !config.services.dae.enable || config.services.mihomo.enable;
          message = "profiles.services.proxy.dae.enable requires profiles.services.proxy.mihomo.enable.";
        }
      ];
    };
}

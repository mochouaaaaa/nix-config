{
  flake.modules.nixos."services.proxy" =
    {
      pkgs,
      lib,
      config,
      options,
      ...
    }:
    let
      cfg = config.profiles.services.proxy.mihomo;
    in
    {
      config = lib.mkMerge [
        (lib.mkIf (options ? age) {
          # profiles.services.proxy.mihomo.subscriptionEnvironmentFile =
          #   lib.mkDefault config.age.secrets.subscription.path;
        })

        # Keep the dependency one-way: DNS works without the proxy module,
        # while an imported proxy module can optionally provide its endpoint.
        (lib.optionalAttrs (options ? profiles.services.dns) {
          profiles.services.dns = {
            mihomoSocksAddress = "${cfg.address}:${toString cfg.socks.port}";
            mihomoDNSListen = "${cfg.address}:${toString cfg.dns.listen}";
            mihomoEnable = true;
          };
        })

        (lib.mkIf (cfg.subscriptionEnvironmentFile == null || cfg.subscriptionEnvironmentFile == "") {
          services = {
            mihomo.enable = lib.mkForce false;
            dae.enable = lib.mkForce false;
          };
        })
        (lib.mkMerge [
          {
            services.mihomo = {
              enable = true;
              webui = pkgs.metacubexd;
              configFile = ./mihomo.yaml;
              processesInfo = true;
            };

            systemd.services.mihomo-config = {
              description = "Generate Mihomo configuration";

              serviceConfig = {
                Type = "oneshot";
                EnvironmentFile = lib.optional (
                  cfg.subscriptionEnvironmentFile != null
                ) cfg.subscriptionEnvironmentFile;

                Environment = [
                  "MIHOMO_HTTP_PORT=${toString cfg.http.port}"
                  "MIHOMO_SOCKS_PORT=${toString cfg.socks.port}"
                  "MIHOMO_DNS_ENABLE=true"
                  "MIHOMO_DNS_LISTEN=${cfg.address}:${toString cfg.dns.listen}"
                  "MIHOMO_DNS_IPV6=${builtins.toJSON cfg.dns.ipv6}"
                ];

                RuntimeDirectory = "mihomo-config";
                RuntimeDirectoryMode = "0700";
                RuntimeDirectoryPreserve = "yes";

                ExecStart = pkgs.writeScript "mihomo-config-generator" ''
                  #!${pkgs.python3}/bin/python3
                  import os
                  from pathlib import Path
                  from string import Template

                  template = Path("${config.services.mihomo.configFile}")
                  output = Path("/run/mihomo-config/config.yaml")

                  envs = os.environ
                  content = template.read_text()
                  content = Template(content).safe_substitute(**envs)

                  output.write_text(content)
                  output.chmod(0o600)
                '';
              };
            };

            systemd.services.mihomo = {
              requires = [ "mihomo-config.service" ];
              after = [ "mihomo-config.service" ];

              serviceConfig = {
                LoadCredential = lib.mkForce "config.yaml:/run/mihomo-config/config.yaml";
                RestrictAddressFamilies = [
                  "AF_UNIX"
                  "AF_NETLINK"
                ];
              };
            };
          }

          (lib.mkIf config.services.mihomo.tunMode {
            networking.firewall.checkReversePath = lib.mkDefault "loose";
          })
        ])
      ];
    };

  flake.modules.nixos.preservation = { lib, config, ... }: {
    profiles.preservation.directories = lib.optionals config.services.mihomo.enable [
      "/var/lib/private/mihomo"
    ];
  };

}

{
  self,
  inputs,
  ...
}:
{

  flake.modules.nixos.agenix =
    {
      config,
      lib,
      pkgs,
      hostName,
      ...
    }:
    {
      imports = [
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
      ];

      services.openssh.enable = true;

      age = {
        rekey = {
          masterIdentities = [ "${inputs.mysecrets}/master.age" ];
          storageMode = "local";
          localStorageDir =
            self.outPath + "/secrets/rekeyed/nixos/${hostName}/${pkgs.stdenv.hostPlatform.system}";
        };

        secrets = {
          subscription = {
            rekeyFile = ./subscription.age;
          };
          next_dns_server = {
            rekeyFile = ./next_dns_server.env;
          };
        };

      };

      systemd.services.mosdns.serviceConfig = {
        EnvironmentFile = config.age.secrets.next_dns_server.path;
      };

      systemd.services.mihomo-config = lib.mkIf config.services.mihomo.enable {
        description = "Generate Mihomo configuration";

        serviceConfig = {
          Type = "oneshot";
          EnvironmentFile = config.age.secrets.subscription.path;

          Environment = [
            "MIHOMO_HTTP_PORT=${toString config.profiles.services.proxy.mihomo.http.port}"
            "MIHOMO_SOCKS_PORT=${toString config.profiles.services.proxy.mihomo.socks.port}"
            "MIHOMO_DNS_ENABLE=${if config.profiles.services.proxy.mihomo.dns.enable then "true" else "false"}"
            "MIHOMO_DNS_LISTEN=${config.profiles.services.proxy.mihomo.dns.listen}"
            "MIHOMO_DNS_IPV6=${if config.profiles.services.proxy.mihomo.dns.ipv6 then "true" else "false"}"
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
            content = Template(content).substitute(**envs)

            output.write_text(content)
            output.chmod(0o600)
          '';
        };
      };

      systemd.services.mihomo = lib.mkIf config.services.mihomo.enable {
        requires = [ "mihomo-config.service" ];
        after = [ "mihomo-config.service" ];

        serviceConfig.LoadCredential = lib.mkForce "config.yaml:/run/mihomo-config/config.yaml";
      };

    };

}

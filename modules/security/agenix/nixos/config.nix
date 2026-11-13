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
            self.outPath + "/secrets/rekeyed/${config.networking.hostName}/${pkgs.stdenv.hostPlatform.system}";
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
  
            RuntimeDirectory = "mihomo-config";
            RuntimeDirectoryMode = "0700";
            RuntimeDirectoryPreserve = "yes";
  
            ExecStart = pkgs.writeScript "mihomo-config-generator" ''
              #!${pkgs.python3}/bin/python3
              import os
              from pathlib import Path
  
              template = Path("${config.services.mihomo.configFile}")
              output = Path("/run/mihomo-config/config.yaml")
  
              subscription = os.environ["subscription"]
              content = template.read_text()
              content = content.replace("''${subscription}", subscription)
  
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

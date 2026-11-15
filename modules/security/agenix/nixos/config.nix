{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.agenix =
    {
      config,
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

    };
}

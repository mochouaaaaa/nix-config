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

      profiles.services.proxy.mihomo.subscriptionEnvironmentFile =
        lib.mkIf config.profiles.services.proxy.mihomo.enable config.age.secrets.subscription.path;

      systemd.services.mosdns.serviceConfig = {
        EnvironmentFile = config.age.secrets.next_dns_server.path;
      };

    };

}

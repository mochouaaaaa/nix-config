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

      config = lib.mkMerge [
        {
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
                group = "vm-secrets";
                mode = "0440";
              };
              next_dns_server = {
                rekeyFile = ./next_dns_server.env;
                group = "vm-secrets";
                mode = "0440";
              };
            };
          };

          systemd.services.mosdns.serviceConfig = {
            EnvironmentFile = config.age.secrets.next_dns_server.path;
          };
        }

        (lib.mkIf config.profiles.services.proxy.mihomo.enable {
          profiles.services.proxy.mihomo.subscriptionEnvironmentFile = config.age.secrets.subscription.path;
        })
      ];
    };

}

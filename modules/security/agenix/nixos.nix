{
  flake.modules.nixos.agenix =
    {
      self,
      inputs,
      config,
      pkgs,
      hostName,
      ...
    }:
    let
      inherit (inputs) mysecrets;
    in
    {
      imports = [
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
      ];

      home-manager.sharedModules = [
        self.modules.homeManager.agenix
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
            rekeyFile = "${mysecrets}/nixos/subscription.age";
          };
          next_dns_server = {
            rekeyFile = "${mysecrets}/nixos/next_dns_server.env";
          };
        };
      };

      systemd.services.mosdns.serviceConfig = {
        EnvironmentFile = config.age.secrets.next_dns_server.path;
      };

    };
}

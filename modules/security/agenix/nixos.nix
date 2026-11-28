{ inputs, ... }:

let
  flakeAspectsLib = inputs.flake-aspects.lib inputs.nixpkgs.lib;
in
{
  flake.aspects = { aspects, ... }: {
    "agenix" = {
      includes = [
        (flakeAspectsLib.forward {
          each = [ null ];
          fromClass = _: "homeManager";
          intoClass = _: "nixos";
          intoPath = _: [ "home-manager" "sharedModules" ];
          # Forward only the Home Manager class, not the whole agenix aspect.
          fromAspect = _: {
            homeManager = aspects.agenix.homeManager;
          };
        })
      ];

      nixos =
        {
          self,
          inputs,
          config,
          lib,
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

          services.openssh.enable = true;

          age = {
            rekey = {
              masterIdentities = [
                {
                  identity = "${mysecrets}/master.age";
                  pubkey = lib.strings.trim (builtins.readFile "${mysecrets}/master.pub");
                }
              ];
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
    };
  };
}

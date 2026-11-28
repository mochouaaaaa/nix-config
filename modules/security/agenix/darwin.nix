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
          intoClass = _: "darwin";
          intoPath = _: [
            "home-manager"
            "sharedModules"
          ];
          fromAspect = _: aspects.agenix;
        })
      ];

      darwin =
        {
          self,
          inputs,
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
            inputs.agenix.darwinModules.default
            inputs.agenix-rekey.darwinModules.default
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
                self.outPath + "/secrets/rekeyed/darwin/${pkgs.stdenv.hostPlatform.system}/${hostName}";
            };
          };
        };
    };
  };
}

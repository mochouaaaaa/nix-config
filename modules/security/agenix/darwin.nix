{

  flake.modules.darwin.agenix =
    {
      self,
      lib,
      pkgs,
      inputs,
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

      home-manager.sharedModules = [
        self.modules.homeManager.agenix
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

}

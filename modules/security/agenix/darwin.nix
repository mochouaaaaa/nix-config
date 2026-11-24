{

  flake.modules.darwin.agenix =
    {
      self,
      pkgs,
      inputs,
      hostName,
      ...
    }:
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
          masterIdentities = [ "${inputs.mysecrets}/master.age" ];
          storageMode = "local";
          localStorageDir =
            self.outPath + "/secrets/rekeyed/darwin/${pkgs.stdenv.hostPlatform.system}/${hostName}";
        };

      };
    };

}

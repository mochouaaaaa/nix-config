{
  self,
  inputs,
  ...
}:
{

  flake.modules.darwin.agenix = { pkgs, hostName, ... }: {
    imports = [
      inputs.agenix.darwinModules.default
      inputs.agenix-rekey.darwinModules.default
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

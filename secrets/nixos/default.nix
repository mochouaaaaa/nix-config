{
  inputs,
  config,
  lib,
  self,
  ...

}:
let
  isSecret = lib.hasAttr "mysecrets" inputs;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  config = lib.mkIf isSecret {

    age = {
      rekey = {
        masterIdentities = [ "${inputs.mysecrets}/master.age" ];
        storageMode = "local";
        localStorageDir = "${self}/secrets/rekeyed/${config.networking.hostName}";
      };

    };

  };

}

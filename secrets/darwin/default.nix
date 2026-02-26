{
  lib,
  inputs,
  config,
  self,
  ...
}:
let
  isSecret = lib.hasAttr "mysecrets" inputs;
in
{
  imports = [
    inputs.agenix.darwinModules.default
    inputs.agenix-rekey.darwinModules.default
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

{
  inputs,
  pkgs,
  config,
  ...

}:
let
  inherit (inputs) mysecrets;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  config = {
    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
    ];

    age = {
      identityPaths =
        if config.preservation.enable then
          [ "/nix/persistence/etc/ssh/ssh_host_ed25519_key" ]
        else
          [ "/etc/ssh/ssh_host_ed25519_key" ];

      secrets = {

      };
    };

  };

}

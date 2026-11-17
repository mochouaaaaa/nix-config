{
  inputs,
  self,
  lib,
  ...
}:
{
  flake.deploy.nodes."mochou@vm" = {
    hostname = "192.168.122.246";
    sshUser = "root";
    remoteBuild = true;

    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."mochou@vm";
    };
  };

  perSystem =
    { system, ... }:
    {
      checks = lib.optionalAttrs (builtins.getEnv "NIX_CONFIG_CHECK" != "1") (
        inputs.deploy-rs.lib.${system}.deployChecks self.deploy
      );
    };
}

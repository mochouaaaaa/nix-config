{
  inputs,
  self,
  ...
}:
{
  flake.deploy.nodes.remote = {
    hostname = "192.168.122.62";
    sshUser = "root";
    remoteBuild = false;
    fastConnection = true;

    profiles.system = {
      user = "root";
      activationTimeout = 1800;
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.remote;
    };
  };

  perSystem =
    { system, lib, ... }:
    let
      deploySupported = system != "x86_64-darwin" && builtins.hasAttr system inputs.deploy-rs.packages;
    in
    {
      devShell.packages = lib.optional deploySupported inputs.deploy-rs.packages.${system}.deploy-rs;

      checks =
        if deploySupported && builtins.getEnv "NIX_CONFIG_CHECK" != "1" then
          inputs.deploy-rs.lib.${system}.deployChecks self.deploy
        else
          { };
    };

}

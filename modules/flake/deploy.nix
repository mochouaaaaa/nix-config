{
  inputs,
  self,
  ...
}:
{
  flake.deploy.nodes."mochou@vm" = {
    hostname = "192.168.122.246";
    sshUser = "root";
    remoteBuild = false;
    fastConnection = true;

    profiles.system = {
      user = "root";
      activationTimeout = 1800;
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."mochou@vm";
    };
  };
}

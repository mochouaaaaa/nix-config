{
  inputs,
  pkgs,
  config,
  mysecrets,
  ...

}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [
    inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  age = {
    identityPaths =
      if config.preservation.enable then
        [ "/persistent/etc/ssh/ssh_host_ed25519_key" ]
      else
        [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      userPassword = {
        file = "${mysecrets}/user_password.age";
        owner = "root";
        group = "root";
        mode = "0400";
      };
      rootPassword = {
        file = "${mysecrets}/root_password.age";
        owner = "root";
        group = "root";
        mode = "0400";
      };

    };

  };

}

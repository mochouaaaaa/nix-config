{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.agenix.homeManagerModules.default ];

  home.packages = [
    inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    secrets = {
      fittencode = {
        file = ../secrets/fittencode.age;
      };
    };
  };

}

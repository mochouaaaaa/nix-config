{
  self,
  config,
  inputs,
  pkgs,
  lib,
  isNixos,
  ...
}:
let
  inherit (inputs) mysecrets;
in
{
  imports = [ inputs.agenix.homeManagerModules.default ];

  home.packages = lib.optionals (!isNixos) [
    inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      # email = {
      # file = "${mysecrets}/useremail.age";
      # };
      fittencode = {
        file = "${mysecrets}/fittencode.age";
        path = "${config.xdg.dataHome}/nvim/fittencode/api_key.json";
        mode = "644";
      };
      gemini_env = {
        file = "${mysecrets}/gemini_env.age";
        path = "${config.home.homeDirectory}/.gemini/.env";
        mode = "644";
      };
    };
  };

}

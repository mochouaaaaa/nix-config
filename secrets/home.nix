{
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

  config = {

    home.packages = lib.optionals (!isNixos) [
      inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
    ];

    age = {
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

      secrets = {
        wallhavenApiKey = {
          file = "${mysecrets}/wallhavenApiKey.age";
        };
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
        github_token = {
          file = "${mysecrets}/github_token.age";
        };
      };
    };

    programs = {
      zsh.envExtra = lib.mkBefore ''
        GITHUB_TOKEN_FILE="${config.age.secrets.github_token.path}"
        if [[ -r "$GITHUB_TOKEN_FILE" ]]; then
          export GITHUB_TOKEN="$(<"$GITHUB_TOKEN_FILE")"
        fi
      '';
    };

  };
}

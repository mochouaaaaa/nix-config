{
  self,
  inputs,
  ...
}:
{

  flake.modules.homeManager.agenix =
    {
      config,
      lib,
      pkgs,

      hostName,
      ...
    }:
    {
      imports = [
        inputs.agenix.homeManagerModules.default
        inputs.agenix-rekey.homeManagerModules.default
      ];

      config = {
        age = {
          rekey = {
            masterIdentities = [ "${inputs.mysecrets}/master.age" ];
            storageMode = "local";
            localStorageDir =
              self.outPath
              + "/secrets/rekeyed/home/${config.home.username}/${hostName}/${pkgs.stdenv.hostPlatform.system}";
          };

          secrets = {
            wallhavenApiKey = {
              rekeyFile = ./wallhavenApiKey.age;
            };
            fittencode = {
              rekeyFile = ./fittencode.age;
              path = "${config.xdg.dataHome}/nvim/fittencode/api_key.json";
              mode = "644";
            };
            gemini_env = {
              rekeyFile = ./gemini_env.age;
              path = "${config.home.homeDirectory}/.gemini/.env";
              mode = "644";
            };
            github_token = {
              rekeyFile = ./github_token.age;
            };
            vicinae_github = {
              rekeyFile = ./vicinae-github.age;
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

        programs.vicinae.settings = {
          imports = [
            "${config.age.secrets.vicinae_github.path}"
          ];
        };

      };
    };

}

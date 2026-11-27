{

  flake.aspects."agenix".homeManager =
    {
      self,
      config,
      lib,
      pkgs,
      inputs,
      hostName,
      ...
    }:
    {
      imports = [
        inputs.agenix.homeManagerModules.default
        inputs.agenix-rekey.homeManagerModules.default
      ];

      config =
        let
          inherit (inputs) mysecrets;
        in
        {
          age = {
            rekey = {
              masterIdentities = [
                {
                  identity = "${mysecrets}/master.age";
                  pubkey = lib.strings.trim (builtins.readFile "${mysecrets}/master.pub");
                }
              ];
              storageMode = "local";
              localStorageDir =
                self.outPath
                + "/secrets/rekeyed/home/${config.home.username}/${hostName}/${pkgs.stdenv.hostPlatform.system}";
            };

            secrets = {
              fittencode = {
                rekeyFile = "${mysecrets}/home/fittencode.age";
                path = "${config.xdg.dataHome}/nvim/fittencode/api_key.json";
              };
              # gemini_env = {
              #   rekeyFile = "${mysecrets}/home/gemini_env.age";
              #   path = "${config.home.homeDirectory}/.gemini/.env";
              #   mode = "600";
              # };
              github_token = {
                rekeyFile = "${mysecrets}/home/github_token.age";
              };
              vicinae_github = {
                rekeyFile = "${mysecrets}/home/vicinae_github.age";
                path = "${config.xdg.configHome}/vicinae/github";
              };
              codestral = {
                rekeyFile = "${mysecrets}/home/codestral.age";
              };
              gemini = {
                rekeyFile = "${mysecrets}/home/gemini.age";
              };
            };

          };

          programs = {
            zsh.envExtra = lib.mkBefore ''
              export GITHUB_TOKEN="$(<"${config.age.secrets.github_token.path}")"
              export CODESTRAL_API_KEY="$(<${config.age.secrets.codestral.path})"
              export GEMINI_API_KEY="$(<${config.age.secrets.gemini.path})"
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

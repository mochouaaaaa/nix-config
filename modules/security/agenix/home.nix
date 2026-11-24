{

  flake.modules.homeManager.agenix =
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
              masterIdentities = [ "${mysecrets}/master.age" ];
              storageMode = "local";
              localStorageDir =
                self.outPath
                + "/secrets/rekeyed/home/${config.home.username}/${hostName}/${pkgs.stdenv.hostPlatform.system}";
            };

            secrets = {
              # fittencode = {
              #   rekeyFile = "${mysecrets}/home/fittencode.age";
              #   path = "${config.xdg.dataHome}/nvim/fittencode/api_key.json";
              #   mode = "600";
              # };
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
              GITHUB_TOKEN_FILE="${config.age.secrets.github_token.path}"
              if [[ -r "$GITHUB_TOKEN_FILE" ]]; then
                export GITHUB_TOKEN="$(<"$GITHUB_TOKEN_FILE")"
              fi

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

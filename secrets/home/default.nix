{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  isSecret = lib.hasAttr "mysecrets" inputs;

  cfg = config.profiles.secrets;
in
{
  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.agenix-rekey.homeManagerModules.default
  ];

  options.profiles.secrets = {
    identityPaths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      description = "The path to the private key of the age identity.";
    };
    hostPubkey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The public key of the host machine, used to encrypt secrets.";
    };
    masterIdentities = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ "${inputs.mysecrets}/master.age" ];
      description = "The path to the master age identities.";
    };
  };

  config = lib.mkIf isSecret {

    age = {
      identityPaths = cfg.identityPaths;

      rekey = {
        hostPubkey = cfg.hostPubkey;
        masterIdentities = cfg.masterIdentities;
        storageMode = "local";
        localStorageDir = "${self}/secrets/rekeyed/${config.home.username}";
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

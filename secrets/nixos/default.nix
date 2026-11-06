{
  inputs,
  config,
  lib,
  self,
  pkgs,
  ...

}:
let
  isSecret = lib.hasAttr "mysecrets" inputs;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  config = lib.mkIf isSecret {

    age = {
      rekey = {
        masterIdentities = [ "${inputs.mysecrets}/master.age" ];
        storageMode = "local";
        localStorageDir = "${self}/secrets/rekeyed/${config.networking.hostName}/${pkgs.stdenv.hostPlatform.system}/${builtins.hashString "md5" config.age.rekey.hostPubkey}";
      };

      secrets = {
        subscription = {
          rekeyFile = ./subscription.age;
        };
      };

    };

    systemd.services.mihomo-config = {
      description = "Generate Mihomo configuration";

      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = config.age.secrets.subscription.path;

        RuntimeDirectory = "mihomo-config";
        RuntimeDirectoryMode = "0700";
        RuntimeDirectoryPreserve = "yes";

        ExecStart = pkgs.writeScript "mihomo-config-generator" ''
          #!${pkgs.python3}/bin/python3
          import os
          from pathlib import Path

          template = Path("${config.services.mihomo.configFile}")
          output = Path("/run/mihomo-config/config.yaml")

          subscription = os.environ["subscription"]
          content = template.read_text()
          content = content.replace("''${subscription}", subscription)

          output.write_text(content)
          output.chmod(0o600)
        '';
      };
    };

    systemd.services.mihomo = {
      requires = [ "mihomo-config.service" ];
      after = [ "mihomo-config.service" ];

      serviceConfig.LoadCredential = lib.mkForce "config.yaml:/run/mihomo-config/config.yaml";
    };

  };

}

{
  inputs,
  pkgs,
  config,
  lib,
  ...

}:
let
  isSecret = lib.hasAttr "mysecrets" inputs;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  config = lib.mkIf isSecret {
    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
    ];

    age =
      let
        inherit (inputs) mysecrets;
      in
      {
        identityPaths =
          if config.preservation.enable then
            [ "/nix/persistence/etc/ssh/ssh_host_ed25519_key" ]
          else
            [ "/etc/ssh/ssh_host_ed25519_key" ];

        secretsDir = "/var/agenix";
        secretsMountPoint = "/var/agenix.d";
        secrets = {
          home_wifi_pwd = {
            file = ./home_wifi_pwd.age;
          };
          next_dns_server = {
            file = ./next_dns_server.env;
          };
        };
      };

    networking = {
      # desktop need its cli for status bar
      networkmanager = {
        ensureProfiles = {
          environmentFiles = [
            "${config.age.secrets.home_wifi_pwd.path}"
          ];
        };
      };
    };

    systemd.services.mosdns.serviceConfig = {
      EnvironmentFile = config.age.secrets.next_dns_server.path;
    };

  };

}

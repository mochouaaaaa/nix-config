{
  config,
  ...
}:
{
  age = {
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHr1vGyGMSH/p7w+vAJIgvrr+z9TPvAfJJMJh1v+SUx";
    };
    secrets = {
      home_wifi_pwd = {
        rekeyFile = ./home_wifi_pwd.age;
      };
      next_dns_server = {
        rekeyFile = ./next_dns_server.env;
      };
    };

  };

  networking = {
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
}

{
  lib,
  options,
  config,
  ...
}:
{
  config = lib.optionalAttrs (options ? age) {
    # Keep the Home Manager rekey identity next to the system secret identity.
    home-manager.sharedModules = [
      {
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECNEOhSUgaHrFy8WYaHcFTTyeBDaS2bNXj/mE7RCkGo";
      }
    ];

    age = {
      rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHr1vGyGMSH/p7w+vAJIgvrr+z9TPvAfJJMJh1v+SUx";

      secrets.home_wifi_pwd = {
        rekeyFile = ./home_wifi_pwd.age;
      };
    };

    networking.networkmanager.ensureProfiles.environmentFiles = [
      config.age.secrets.home_wifi_pwd.path
    ];
  };
}

{
  flake.modules.nixos."services.base" = {
    services.openssh = {
      enable = true;
      settings = {
        PubkeyAuthentication = "yes";

        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
        X11Forwarding = false;

        UsePAM = true;
      };
    };

    programs.ssh.startAgent = false;
  };

  flake.modules.nixos.preservation = { lib, config, ... }: {
    profiles.preservation.files = lib.optionals config.services.openssh.enable [
      {
        file = "/etc/ssh/ssh_host_rsa_key";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key.pub";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key.pub";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
    ];
  };

  flake.modules.darwin.services = {
    services.openssh.enable = true;
  };
}

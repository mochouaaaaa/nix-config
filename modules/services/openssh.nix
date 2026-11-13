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

  flake.modules.nixos.preservation = {
    profiles.preservation.files = [
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

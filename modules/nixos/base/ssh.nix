{ lib, ... }:
{

  networking.firewall.enable = lib.mkDefault false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "yes";
      #   root user is used for remote deployment, so we need to allow it
      #   PermitRootLogin = "prohibit-password";
      #   PasswordAuthentication = false; # disable password login
    };
    # openFirewall = true;
  };

  programs.ssh.startAgent = false;

  preservation.preserveAt."/nix/persistence" = {
    files = [
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
}

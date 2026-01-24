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

  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = lib.mkDefault true;
}

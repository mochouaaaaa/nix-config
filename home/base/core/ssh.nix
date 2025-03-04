{isDarwin, ...}: {
  programs.ssh = {
    enable = true;

    # All my ssh private key are generated by `ssh-keygen -t ed25519 -a 256 -C "xxx@xxx"`
    # Config format:
    #   Host —  given the pattern used to match against the host name given on the command line.
    #   HostName — specify nickname or abbreviation for host
    #   IdentityFile — the location of your SSH key authentication file for the account.
    # Format in details:
    #   https://www.ssh.com/academy/ssh/config
    extraConfig = ''
      Host github.com
        AddKeysToAgent yes
        ${
        if isDarwin
        then "UseKeychain yes"
        else ""
      }
        IdentityFile ~/.ssh/github
    '';
  };
}

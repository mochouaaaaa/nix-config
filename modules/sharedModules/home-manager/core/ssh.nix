{
  pkgs,
  lib,
  ...
}:
{
  config = {
    programs.ssh = {
      enable = true;

      enableDefaultConfig = false;

      # matchBlocks."*" = {
      #   forwardAgent = false;
      #   addKeysToAgent = "no";
      #   compression = false;
      #   serverAliveInterval = 0;
      #   serverAliveCountMax = 3;
      #   hashKnownHosts = false;
      #   userKnownHostsFile = "~/.ssh/known_hosts";
      #   controlMaster = "no";
      #   controlPath = "~/.ssh/master-%r@%n:%p";
      #   controlPersist = "no";
      #   extraOptions = {
      #     ObscureKeystrokeTiming = "no";
      #   };
      # };

      settings = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          ObscureKeystrokeTiming = "no";
        };
        "github.com" = {
          HostName = "github.com";
          AddKeysToAgent = "yes";
          IdentityFile = "~/.ssh/github";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          UseKeychain = "yes";
        };
      };
    };
  };
}

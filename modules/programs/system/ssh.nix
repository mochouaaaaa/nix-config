{
  flake.modules.homeManager."system.ssh" = { lib, config, ... }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [ "~/.ssh/config.d/*.conf" ];

      settings = {
        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
          ObscureKeystrokeTiming = "no";
        };

        "github.com" = {
          hostname = "github.com";
          addKeysToAgent = "yes";
          identityFile = "~/.ssh/github";
        };
      };
    };

    home.activation.createSshConfigDir = lib.mkIf config.programs.ssh.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.ssh/config.d"
      ''
    );

  };

  flake.modules.homeManager.darwin = {
    programs.ssh.settings."github.com".UseKeychain = "yes";
  };
}

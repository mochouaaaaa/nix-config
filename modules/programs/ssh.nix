{
  flake.modules.homeManager.programs = {

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

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
          ObscureKeystrokeTiming = "no"; # 从 extraOptions 移出，直接用指令名
        };

        "github.com" = {
          hostname = "github.com";
          addKeysToAgent = "yes";
          identityFile = "~/.ssh/github";
        };
      };
    };

  };

  flake.modules.homeManager.darwin = {

    programs.ssh = {
      matchBlocks."github.com" = {
        useKeychain = "yes";
      };
    };

  };

}

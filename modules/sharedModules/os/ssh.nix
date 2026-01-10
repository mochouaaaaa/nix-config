{
  services.openssh = {
    enable = true;
  };

  programs = rec {
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    ssh.startAgent = !gnupg.agent.enableSSHSupport;
  };

}

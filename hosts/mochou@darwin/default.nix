{
  self,
  username,
  hostName,
  system,
  ...
}:
{
  imports = [
    self.modules.darwin.default
    self.modules.darwin."services.virtualisation.orbstack"
  ];

  networking.hostName = hostName;
  nixpkgs.hostPlatform = system;

  home-manager = {
    sharedModules = [
      {
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTnhFwOTyrb2gMvEyV6I83L7Xrek8bnzcg2FW6UahY";
      }
    ];

    users.${username} = {
      imports = [
        self.modules.homeManager.host
        self.modules.homeManager.workstation
        self.modules.homeManager.darwin
        self.modules.homeManager."programs.codex"
      ];
    };
  };
}

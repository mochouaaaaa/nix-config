{
  self,
  username,
  hostName,
  ...
}:
{
  imports = [
    self.modules.darwin.agenix
    self.modules.darwin.default
    self.modules.darwin."services.virtualisation.orbstack"
  ];

  networking.hostName = hostName;

  home-manager.users.${username}.imports = [
    self.modules.homeManager.host
    self.modules.homeManager.workstation
    self.modules.homeManager."desktop.programs.api-clients"
    self.modules.homeManager."desktop.programs.browsers"
    self.modules.homeManager.darwin
    self.modules.homeManager."agents.codex"
  ];
}

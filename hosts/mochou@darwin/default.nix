{
  self,
  username,
  hostName,
  ...
}:
{
  imports = [
    self.modules.darwin."host.${username}.${hostName}"
    self.modules.darwin.agenix
    self.modules.darwin.appearance
    self.modules.darwin."services.virtualisation.orbstack"
  ];

  networking.hostName = hostName;
}

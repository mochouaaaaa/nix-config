{
  self,
  hostName,
  ...
}:
{
  imports = [
    self.modules.darwin."host.${hostName}"
    self.modules.darwin.agenix
    self.modules.darwin.appearance
    self.modules.darwin."services.virtualisation.orbstack"
  ];

  networking.hostName = hostName;
}

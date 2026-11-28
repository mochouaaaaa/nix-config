{
  self,
  hostName,
  ...
}:
{
  imports = [
    self.modules.darwin."host.mochou.darwin"
    self.modules.darwin.agenix
    self.modules.darwin.appearance
    self.modules.darwin."services.virtualisation.orbstack"
  ];

  networking.hostName = hostName;
}

{
  self,
  ...
}:
{
  imports = [
    self.nixosModules.secrets
  ];
}

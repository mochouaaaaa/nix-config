{ self, ... }:
{
  # Keep each database independently importable; this bundle preserves the
  # current workstation host's combined database setup as an opt-in entry.
  flake.modules.nixos."services.databases" = {
    imports = [
      self.modules.nixos."services.mysql"
      self.modules.nixos."services.postgresql"
      self.modules.nixos."services.redis"
    ];
  };
}

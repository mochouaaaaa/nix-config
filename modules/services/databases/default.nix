{
  # Keep each database independently importable; this bundle preserves the
  # current workstation host's combined database setup as an opt-in entry.
  flake.aspects."services.databases"."nixos" = { self, ... }: {

    imports = [
      self.modules.nixos."services.mysql"
      self.modules.nixos."services.postgresql"
      self.modules.nixos."services.redis"
    ];

  };
}

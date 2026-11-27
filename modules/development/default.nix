{ self, ... }:
{
  # Atomic language modules remain independently importable.
  flake.aspects."development.languages"."homeManager" = {
    imports = [
      self.modules.homeManager."development.go"
      self.modules.homeManager."development.node"
      self.modules.homeManager."development.python"
      self.modules.homeManager."development.rust"
    ];
  };

}

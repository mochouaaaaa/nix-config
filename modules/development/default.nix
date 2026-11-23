{ self, ... }:
{
  # Atomic language modules remain independently importable.
  flake.modules.homeManager."development.languages" = {
    imports = [
      self.modules.homeManager."development.go"
      self.modules.homeManager."development.node"
      self.modules.homeManager."development.python"
      self.modules.homeManager."development.rust"
    ];
  };

}

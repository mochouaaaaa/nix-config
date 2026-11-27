{ self, ... }:
{
  # Platform-neutral workstation role. Platform-specific integration remains
  # in homeManager.linux and homeManager.darwin.
  flake.aspects."workstation"."homeManager" = {
    imports = [
      self.modules.homeManager.cli
      self.modules.homeManager."development.languages"
      self.modules.homeManager."programs.vscode"
      self.modules.homeManager."programs.kitty"
      self.modules.homeManager."desktop.programs.database"
    ];
  };
}

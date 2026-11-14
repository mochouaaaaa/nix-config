{ self, ... }:
{
  # Platform-neutral workstation role. Platform-specific integration remains
  # in homeManager.linux and homeManager.darwin.
  flake.modules.homeManager.workstation = {
    imports = [
      self.modules.homeManager.cli
      self.modules.homeManager.development
      self.modules.homeManager."appearance.font-options"
      self.modules.homeManager."cli.neovim"
      self.modules.homeManager."programs.vscode"
      self.modules.homeManager."programs.kitty"
      self.modules.homeManager."desktop.programs.browsers"
      self.modules.homeManager."desktop.programs.database"
      self.modules.homeManager."desktop.programs.networking"
    ];
    profiles.database-clients.enable = true;
  };
}

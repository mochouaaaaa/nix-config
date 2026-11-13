{ self, ... }:
{
  # Platform-neutral workstation tools shared by NixOS and nix-darwin.
  # OS-specific package and integration overrides stay in homeManager.linux
  # and homeManager.darwin respectively.
  flake.modules.homeManager.workstation = {
    imports = [
      self.modules.homeManager.development
      self.modules.homeManager."appearance.font-options"
      self.modules.homeManager."programs.neovim"
      self.modules.homeManager."programs.vscode"
      self.modules.homeManager."programs.kitty"
    ];
  };
}

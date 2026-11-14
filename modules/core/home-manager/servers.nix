{ self, ... }:
{
  # Headless/server role: shared CLI and administration tools without
  # workstation editors, terminal emulator, fonts, or desktop applications.
  flake.modules.homeManager.servers = {
    imports = [ self.modules.homeManager.cli ];
  };
}

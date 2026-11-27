{ self, ... }:
{
  # Headless/server role: shared CLI and administration tools without
  # graphical editors, terminal emulator, fonts, or desktop applications.
  flake.aspects."servers"."homeManager" = {
    imports = [ self.modules.homeManager.cli ];
  };
}

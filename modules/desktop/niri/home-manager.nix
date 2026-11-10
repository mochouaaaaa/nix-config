{ self, ... }:
{
  flake.modules.homeManager."desktop.niri" = {
    imports = [
      self.modules.homeManager."desktop.shell.noctalia"
    ];

    services.cliphist.enable = true;
  };
}

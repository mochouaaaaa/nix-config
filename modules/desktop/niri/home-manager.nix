{ self, ... }:
{
  flake.modules.homeManager."desktop.niri" = {
    imports = [
      self.modules.homeManager."desktop.shell.noctalia"
    ];

    wayland.windowManager.niri.enable = true;

    services.cliphist.enable = true;
  };
}

{ self, ... }:
{
  flake.modules.homeManager."desktop.niri" = {
    imports = [
      self.modules.homeManager."desktop.shell.noctalia"
    ];

    wayland.windowManager.niri.enable = true;
    services.xremap.withNiri = true;

    services.cliphist.enable = true;
  };
}

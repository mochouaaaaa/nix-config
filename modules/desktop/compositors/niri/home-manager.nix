{
  flake.aspects = { aspects, ... }: {
    "desktop.niri" = {
      includes = [
        aspects."desktop.shell.noctalia"
      ];

      homeManager = {
        wayland.windowManager.niri.enable = true;
        services.cliphist.enable = true;
      };
    };
  };
}

{
  flake.aspects = { aspects, ... }: {
    "desktop.niri" = {
      includes = [
        aspects."desktop.shell.noctalia"
        aspects."desktop.default-apps"
      ];

      homeManager = {
        wayland.windowManager.niri.enable = true;
        services.cliphist.enable = true;
      };
    };
  };
}

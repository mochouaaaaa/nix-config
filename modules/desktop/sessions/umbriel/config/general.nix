{
  flake.aspects."desktop.umbriel".homeManager = {

    programs.umbriel.settings = {
      general = {
        mod_key = "Super";
        show_cheatsheet = false;
      };
      layout = {
        gap = 4;
      };
      environment = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        SDL_VIDEODRIVER = "wayland";
      };
    };
  };
}

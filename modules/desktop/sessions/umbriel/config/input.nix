{
  flake.aspects.desktop-umbriel.homeManager = { config, ... }: {

    programs.umbriel.settings.input = {
      cursor = {
        size = config.home.pointerCursor.size;
        theme = config.home.pointerCursor.name;
      };
      keyboard = {
        numlock_toggle = true;
        repeat_rate = 50;
        repeat_delay = 200;
      };
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        scroll_factor = 1.15;
      };
    };
  };

}

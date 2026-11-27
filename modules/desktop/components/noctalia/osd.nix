{
  flake.aspects."desktop.shell.noctalia".homeManager = {
    programs.noctalia = {
      settings = {
        osd = {
          border = true;
          enabled = true;
          monitors = [ ];
          offset_x = 20;
          offset_y = 30;
          orientation = "horizontal";
          position = "bottom_center";
          position_vertical = "bottom_center";
          follow_focused_output = true;
          scale = 1.0;
          kinds = {
            bluetooth = true;
            brightness = true;
            caffeine = true;
            dnd = true;
            keyboard_backlight = true;
            keyboard_layout = true;
            lock_keys = true;
            media = true;
            nightlight = true;
            power_profile = true;
            privacy = true;
            volume = true;
            volume_input = true;
            volume_output = true;
            wifi = true;
          };
        };
      };
    };
  };
}

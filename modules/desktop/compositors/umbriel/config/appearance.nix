{
  flake.modules.homeManager."desktop.umbriel" = { mylib, ... }: {

    programs.umbriel.settings.appearance = {
      prefer_no_csd = true;
      border_width = 1;
      corner_radius = 8;
      opaque_fullscreen = true;
      drag_opacity = 0.78;
      blur = mylib.mkForceRecursive {
        enabled = true;
        optimized = false;
        passes = 2;
        radius = 7;
        noise = 0.02;
        brightness = 0.9;
        contrast = 0.9;
        saturation = 1.1;

        # enabled = true;
        # optimized = true;
        # radius = 62;
        # passes = 1;
        # noise = 0.02;
        # contrast = 1.1;
        # saturation = 1.2;
      };
      shadow = {
        enabled = true;
        softness = 30;
        offset_x = 2;
        offset_y = 2;
      };
    };
  };
}

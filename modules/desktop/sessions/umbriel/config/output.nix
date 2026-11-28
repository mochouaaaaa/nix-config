{
  flake.aspects.desktop-umbriel.homeManager = {

    programs.umbriel.settings = {
      output = {
        DP-1 = {
          mode = "3840x2160@60";
          position = [
            0
            0
          ];
          scale = 1.5;
          vrr = "fullscreen";
          hdr = "auto";
        };
      };
    };
  };
}

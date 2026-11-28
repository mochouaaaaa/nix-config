{
  flake.aspects = { aspects, ... }: {
    includes = [ aspects.launcher._.vicinae ];

    desktop-umbriel.homeManager = {
      programs.umbriel.settings = {
        layer_rule = [
          {
            match.namespace = "vicinae";
            blur = true;
            blur_ignore_alpha = 0.6;
            blur_optimized = false;
          }
        ];
      };
    };
  };

}

{
  flake.aspects.desktop-umbriel.homeManager = {

    programs.umbriel.settings.layer_rule = [
      {
        blur = true;
        blur_optimized = true;
        blur_ignore_alpha = 0.6;
      }
      {
        match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|widgets|window-switcher)$";
        blur = true;
        blur_ignore_alpha = 0.5;
        blur_popups = true;
        blur_optimized = false;
      }
    ];
  };
}

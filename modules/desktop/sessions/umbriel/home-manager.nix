{
  flake.aspects = { aspects, ... }: {
    desktop-umbriel = {
      includes = [
        aspects."desktop.shell.noctalia"
      ];

      homeManager = { inputs, ... }: {
        imports = [
          inputs.luciole.homeModules.default
        ];

        programs.luciole = {
          enable = true;
          settings = {
            browser = {
              view_mode = "grid";
              show_hidden = false;
              background_opacity = 0.78;
              chooser_show_preview = true;
              terminal_command = "kitty";
            };
          };
        };
      };
    };
  };
}

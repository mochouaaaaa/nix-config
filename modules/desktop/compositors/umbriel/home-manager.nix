{
  flake.modules.homeManager."desktop.umbriel" = { self, inputs, ... }: {

    imports = [
      self.modules.homeManager."desktop.shell.noctalia"

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
}

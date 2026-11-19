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
        };
      };
    };

  };
}

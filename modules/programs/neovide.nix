{

  flake.modules.homeManager.darwin = { lib, ... }: {
    package = null;
    settings = {
      frame = lib.mkForce "transparent";
    };
  };

  flake.modules.homeManager.programs = { config, ... }: {
    programs.neovide = {
      enable = false;
      settings = {
        fork = true;
        frame = "none";
        idle = true;
        maximized = false;
        neovim-bin = "${config.programs.neovim.package}/bin/nvim";
        no-multigrid = false;
        srgb = true;
        tabs = true;
        theme = "auto";
        mouse-cursor-icon = "arrow";
        title-hidden = true;
        vsync = true;
        wsl = false;
        font = {
          normal = [ "${config.profiles.fonts.default}" ]; # Will use the bundled Fira Code Nerd Font by default
          size = 17;
        };
        box-drawing = {
          mode = "native";
        };
      };
    };
  };

  flake.modules.homeManager."desktop.common" = {
    programs.neovide = {
      settings = {
        wayland-app-id = "org.neovim.Neovide";
      };
    };
  };

  flake.modules.homeManager."desktop.niri" = {
    wayland.windowManager.niri.settings = {
      _children = [
        {
          window-rule._children = [
            {
              match._props.app-id = "^(neovide)$";
            }
            { opacity = 0.85; }
          ];
        }
      ];
    };
  };
}

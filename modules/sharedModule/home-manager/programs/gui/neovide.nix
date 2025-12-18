{ lib, config, ... }:
{

  config = lib.mkIf (config.programs.desktop.enable) {

    programs.neovide = {
      enable = true;
      settings = {
        fork = true;
        frame = "none";
        idle = true;
        maximized = false;
        neovim-bin = "${config.programs.nixvim.package}/bin/nvim";
        no-multigrid = false;
        srgb = true;
        tabs = true;
        theme = "auto";
        mouse-cursor-icon = "arrow";
        title-hidden = true;
        vsync = true;
        wsl = false;
        font = {
          normal = [ "Monaco Nerd Font" ]; # Will use the bundled Fira Code Nerd Font by default
          size = 17;
        };
        box-drawing = {
          mode = "native";
        };
      };
    };

  };
}

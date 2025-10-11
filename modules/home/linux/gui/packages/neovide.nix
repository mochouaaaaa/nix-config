{ lib, config, ... }:
{

  config = lib.mkIf (config.programs.neovide.enable && config.programs.desktop.enable) {

    programs.neovide = {
      settings = {
        wayland-app-id = "org.neovim.Neovide";
      };
    };

  };
}

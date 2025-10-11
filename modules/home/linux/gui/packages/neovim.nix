{ lib, config, ... }:
{

  config = lib.mkIf (config.programs.nixvim.enable && config.programs.desktop.enable) {

    modules'.xdg-mime.editors = lib.mkAfter [
      "nvim.desktop"
    ];

  };
}

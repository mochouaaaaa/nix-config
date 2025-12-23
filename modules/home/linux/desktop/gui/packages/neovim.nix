{
  lib,
  config,
  ...
}:
{

  modules'.xdg-mime.editors =
    lib.mkIf (config.programs.nixvim.enable && config.programs.desktop.enable)
      [
        "nvim.desktop"
      ];

}

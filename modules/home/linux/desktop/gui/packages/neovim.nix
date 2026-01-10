{
  lib,
  config,
  ...
}:
{

  profiles.xdg-mime.editors =
    lib.mkIf (config.programs.nixvim.enable && config.profiles.desktop.enable)
      [
        "nvim.desktop"
      ];

}

{
  lib,
  config,
  pkgs,
  ...
}:
{

  modules'.xdg-mime.editors =
    lib.mkIf (config.programs.nixvim.enable && config.programs.desktop.enable)
      [
        "nvim.desktop"
      ];

  programs.nixvim = {
    extraConfigLuaPre = ''
      vim.env.GI_TYPELIB_PATH = "${pkgs.gobject-introspection}/lib/girepository-1.0";
    '';
  };

  home.packages = [ pkgs.gobject-introspection ];

}

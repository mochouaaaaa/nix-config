{
  pkgs,
  ...
}:
{

  programs.neovim = {
    extraPackages = [
      pkgs.tree-sitter
    ];
    plugins = with pkgs.vimPlugins; [
    ];
  };
}

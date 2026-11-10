{
  pkgs,
  ...
}:
{

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.lua
        p.python
        p.rust
        p.markdown
      ]))
    ];
  };
}

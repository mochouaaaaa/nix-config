{
  flake.modules.homeManager."cli.neovim.plugins.treesitter" = { pkgs, ... }: {
    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.lua
        p.go
        p.python
        p.rust
        p.markdown
      ]))
    ];
  };
}

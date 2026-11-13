{
  flake.modules.homeManager."programs.neovim" = { pkgs, ... }: {

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
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

  };
}

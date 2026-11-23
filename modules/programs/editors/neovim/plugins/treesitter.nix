{
  flake.modules.homeManager."cli.neovim.plugins.treesitter" = { pkgs, ... }: {
    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.lua
        p.yaml
        p.markdown
        p.json5
        p.bash
        p.latex
        p.regex
      ]))
    ];
  };
}

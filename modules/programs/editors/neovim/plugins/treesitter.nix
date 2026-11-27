{
  flake.aspects.editors.provides.neovim.plugins.treesitter.homeManager = { pkgs, ... }: {
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

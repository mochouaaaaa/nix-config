_: {
  flake.aspects = { aspects, ... }: {
    editors.provides.neovim.provides.plugins = {
      includes = [
        aspects.editors._.neovim._.plugins._.treesitter
      ];

      homeManager = { pkgs, ... }: {
        programs.neovim.plugins = with pkgs.vimPlugins; [
          blink-cmp
          markdown-preview-nvim
        ];
      };
    };
  };
}

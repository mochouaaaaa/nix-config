{ ... }:
{
  flake.aspects = { aspects, ... }: {
    editors.provides.neovim.plugins = {
      includes = [
        aspects.editors._.neovim.plugins.treesitter
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

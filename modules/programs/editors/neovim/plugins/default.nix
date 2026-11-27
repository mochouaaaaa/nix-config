{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "cli.neovim.plugins" = {
      includes = [
        aspects."cli.neovim.plugins.treesitter"
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

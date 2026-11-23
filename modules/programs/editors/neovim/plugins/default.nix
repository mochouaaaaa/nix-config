{ self, ... }:
{
  flake.modules.homeManager."cli.neovim.plugins" = { pkgs, ... }: {

    imports = [
      self.modules.homeManager."cli.neovim.plugins.treesitter"
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      blink-cmp
      markdown-preview-nvim
    ];

  };
}

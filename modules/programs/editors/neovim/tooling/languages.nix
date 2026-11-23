{
  flake.modules.homeManager."cli.neovim.tooling.languages" = { pkgs, ... }: {
    programs.neovim.extraPackages = with pkgs; [
      # shell
      bash-language-server
      shfmt

      # lua
      lua-language-server
      stylua
      luajitPackages.luacheck

      # markdown
      markdown-toc
      markdownlint-cli2

      # filetypes
      yaml-language-server
      prettierd
      eslint_d
      actionlint

      # TOML
      taplo

    ];
  };
}

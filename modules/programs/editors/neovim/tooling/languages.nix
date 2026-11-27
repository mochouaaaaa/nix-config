{
  flake.aspects.editors.provides.neovim.tooling.languages.homeManager = { pkgs, ... }: {
    programs.neovim.extraPackages = with pkgs; [
      # shell
      bash-language-server
      shfmt

      # lua
      lua-language-server
      stylua
      luajitPackages.luacheck

      # markdown
      marksman
      markdown-toc
      markdownlint-cli2

      # filetypes
      yaml-language-server
      prettierd
      eslint_d
      actionlint
      vscode-json-languageserver

      # TOML
      taplo

    ];
  };
}

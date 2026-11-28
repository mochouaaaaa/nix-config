{
  flake.aspects.editors.provides.neovim.provides.tooling.provides.languages.homeManager = { pkgs, ... }: {
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

      # containers
      dockerfile-language-server
      docker-compose-language-service

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

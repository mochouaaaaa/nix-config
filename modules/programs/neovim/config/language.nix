{
  flake.modules.homeManager.programs-neovim = { pkgs, ... }: {

    home.packages = with pkgs; [
      # shell
      bash-language-server
      shfmt

      # lua
      lua-language-server
      stylua
      luajitPackages.luacheck

      # markdown
      marksman
      markdownlint-cli2

      # filetypes
      yaml-language-server
      prettierd
      eslint_d
      actionlint

      # TOML
      taplo

      # docker
      dockerfile-language-server
      docker-compose-language-service

      # js/ts
      vtsls
      typescript
      emmet-ls
      vue-language-server
      vscode-langservers-extracted
      stylelint

    ];

  };
}

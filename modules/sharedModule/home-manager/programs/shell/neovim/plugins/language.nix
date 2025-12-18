{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [

      # shell
      bash-language-server
      shfmt

      # lua
      lua-language-server
      stylua
      luajitPackages.luacheck

      # python
      ty
      ruff
      # pylyzer

      # go
      gopls
      gotools
      gofumpt
      # revive
      delve
      goimports-reviser

      # rust
      cargo
      rust-analyzer
      rustfmt

      # c / c++
      llvmPackages_18.clang-tools

      # markdown
      marksman
      # markdownlint-cli2

      # filetypes
      # vscode-json-languageserver
      yaml-language-server
      prettierd
      eslint_d

      # XML
      # html-lsp
      taplo # for TOML

      # docker
      dockerfile-language-server
      docker-compose-language-service

      # Misc
      # nodePackages.cspell
      sqls

      # js/ts
      vtsls
      typescript
      emmet-ls
      vscode-js-debug
      vue-language-server
      # vscode-css-languageserver
      vscode-langservers-extracted

      # yaml
      # actionlint

      # css/js
      stylelint
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      # hyprland
      hyprls
      kdePackages.qtdeclarative
    ];
}

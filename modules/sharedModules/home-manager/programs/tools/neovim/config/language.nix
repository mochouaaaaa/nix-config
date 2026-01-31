{ pkgs, config, ... }:
let
  cfgHyprland = config.wayland.windowManager.hyprland;
in
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

      # c / c++
      # llvmPackages_20.clangUseLLVM
      # llvmPackages_20.clang-tools

      # markdown
      marksman
      # markdownlint-cli2

      # filetypes
      # vscode-json-languageserver
      yaml-language-server
      prettierd
      eslint_d
      actionlint

      # XML
      # html-lsp
      taplo # for TOML

      # docker
      dockerfile-language-server
      docker-compose-language-service

      # Misc
      # nodePackages.cspell
      # sqls

      # js/ts
      vtsls
      typescript
      emmet-ls
      vue-language-server
      vscode-langservers-extracted
      stylelint

      # yaml
      # actionlint

    ]
    ++ lib.optionals (cfgHyprland.enable) [
      # hyprland
      hyprls
      kdePackages.qtdeclarative
    ];
}

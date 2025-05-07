{ pkgs-unstable, ... }:
{
  home.packages =
    with pkgs-unstable;
    [
      # nix
      nil
      nixfmt-rfc-style

      # shell
      bash-language-server
      shfmt

      # lua
      lua-language-server
      stylua
      luajitPackages.luacheck

      # python
      basedpyright
      ruff
      # pylyzer

      # go
      gopls
      gotools
      revive
      goimports-reviser

      # rust
      cargo
      rust-analyzer
      rustfmt

      # markdown
      marksman
      markdownlint-cli2

      # filetypes
      yaml-language-server
      prettierd
      eslint_d

      # XML
      # html-lsp
      taplo # for TOML

      # docker
      dockerfile-language-server-nodejs
      docker-compose-language-service

      # Misc
      nodePackages.cspell
      sqls

      # css/js
      stylelint
    ]
    ++ lib.optionals (pkgs-unstable.stdenv.isLinux) [
      # hyprland
      hyprls
    ];
}

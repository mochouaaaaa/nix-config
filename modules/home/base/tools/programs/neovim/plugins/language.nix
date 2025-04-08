{
  pkgs,
  ...
}:
{
  # programs.neovim.extraPackages = lib.mkBefore (with pkgs; [
  home.packages = with pkgs; [
    # nix
    nil
    nixfmt-rfc-style

    # shell
    bash-language-server
    shfmt

    # lua
    lua-language-server
    stylua
    # luacheck

    # hyprland
    hyprls

    # python
    basedpyright
    ruff
    # pylyzer

    # go
    gopls
    gotools
    goimports-reviser

    # rust
    rust-analyzer
    rustfmt

    # markdown
    marksman
    markdownlint-cli2

    # filetypes
    yaml-language-server
    prettierd
    stylelint
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

  ];
}

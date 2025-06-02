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
      delve
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

      # js/ts
      vscode-js-debug
      typescript

      # css/js
      stylelint
    ]
    ++ lib.optionals (pkgs-unstable.stdenv.isLinux) [
      # hyprland
      hyprls

      (astro-language-server.overrideAttrs (oldAttrs: {
        pnpmDeps = pnpm_9.fetchDeps {
          inherit (oldAttrs)
            pname
            version
            src
            prePnpmInstall
            ;
          pnpmWorkspaces = oldAttrs.pnpmWorkspaces ++ [
            "@astrojs/ts-plugin"
            "@types/chai"
            "astro-vscode"
            "@astrojs/yaml2ts"
          ];
          hash = "sha256-8lvTVeBEaEVmVWvzzrZlqGZfr9TQ/pCkR8k0Z9GuvUc=";
        };
      }))

    ];
}

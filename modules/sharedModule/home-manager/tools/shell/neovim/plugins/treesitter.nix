{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    tree-sitter
  ];

  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      autoLoad = true;
      settings = {
        auto_install = false;
        highlight.enable = true;
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        regex
        #
        # # git
        git_rebase
        gitignore
        gitcommit
        gitattributes
        git_config
        #
        # # base
        bash
        diff
        comment
        vim
        dockerfile
        #
        # # sql
        sql
        graphql
        #
        # # c
        c
        cpp
        cmake
        swift
        qmljs
        #
        # # lua
        lua
        luap
        #
        # # golang
        go
        gomod
        gosum
        gowork
        #
        # # python
        python
        htmldjango
        #
        # # rust
        rust
        #
        # # javascript
        javascript
        typescript
        tsx
        vue
        scss
        css
        html
        astro
        #
        # # markdown
        markdown
        markdown_inline
        latex
        #
        # # filetype
        yaml
        json
        json5
        jsonc
        toml
        xml
        ini
      ];
    };
  };
}

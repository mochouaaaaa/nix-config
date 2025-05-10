{
  lib,
  pkgs-unstable,
  ...
}:
{
  programs.neovim.extraPackages = lib.mkBefore (
    with pkgs-unstable.vimPlugins;
    [
      nvim-treesitter-textobjects
      nvim-treesitter-parsers.regex

      # git
      nvim-treesitter-parsers.git_rebase
      nvim-treesitter-parsers.gitignore
      nvim-treesitter-parsers.gitcommit
      nvim-treesitter-parsers.gitattributes
      nvim-treesitter-parsers.git_config

      # base
      nvim-treesitter-parsers.bash
      nvim-treesitter-parsers.diff
      nvim-treesitter-parsers.comment
      nvim-treesitter-parsers.vim
      nvim-treesitter-parsers.dockerfile

      # sql
      nvim-treesitter-parsers.sql
      nvim-treesitter-parsers.graphql

      # c
      nvim-treesitter-parsers.c
      nvim-treesitter-parsers.cpp
      nvim-treesitter-parsers.cmake
      nvim-treesitter-parsers.swift

      # lua
      nvim-treesitter-parsers.lua
      nvim-treesitter-parsers.luap

      # golang
      nvim-treesitter-parsers.go
      nvim-treesitter-parsers.gomod
      nvim-treesitter-parsers.gosum
      nvim-treesitter-parsers.gowork

      # python
      nvim-treesitter-parsers.python

      # rust
      nvim-treesitter-parsers.rust

      # javascript
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.typescript
      nvim-treesitter-parsers.tsx
      nvim-treesitter-parsers.vue
      nvim-treesitter-parsers.scss
      nvim-treesitter-parsers.css
      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.astro

      # markdown
      nvim-treesitter-parsers.markdown
      nvim-treesitter-parsers.markdown_inline
      nvim-treesitter-parsers.latex

      # filetype
      nvim-treesitter-parsers.yaml
      nvim-treesitter-parsers.json
      nvim-treesitter-parsers.json5
      nvim-treesitter-parsers.jsonc
      nvim-treesitter-parsers.toml
      nvim-treesitter-parsers.xml
      nvim-treesitter-parsers.ini
    ]
  );
}

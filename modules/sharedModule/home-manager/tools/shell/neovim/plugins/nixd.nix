{
  lib,
  pkgs,
  pkgs-unstable,
  isNixDarwin,
  nixDarwinSystemName,
  isNixos,
  nixosSystemName,
  nixd-name,
  ...
}:
let
  sysHostName = __elemAt (lib.strings.split "@" nixd-name) 2;
in
{
  home.packages = with pkgs-unstable; [
    nixd
    nixfmt-rfc-style
  ];

  programs.nixvim = {
    globals = {
      is_darwin = isNixDarwin;
      is_nixos = isNixos;
    };
    extraConfigLuaPost = ''
      local nixd_lsp_config = function()
          local opts = {}
          local nixd_name = "${nixd-name}"

          if vim.g.is_darwin then
              opts.nix_darwin = {
                  expr = '(builtins.getFlake (builtins.toString ./.)).darwinConfigurations."${
                    if nixDarwinSystemName != "" then nixDarwinSystemName else sysHostName
                  }".options'
              }
          end

          if vim.g.is_nixos then
              opts.nixos = {
                  expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations."${
                    if nixosSystemName != "" then nixosSystemName else sysHostName
                  }".options'
              }
          end

          if nixd_name ~= "" then
              opts.home_manager = {
                  expr = '(builtins.getFlake (builtins.toString ./.)).homeConfigurations."${nixd-name}".options'
              }
          end

          return opts
      end

      local nvim_lsp = require("lspconfig")
      nvim_lsp.nixd.setup({
       cmd = { "nixd" },
       settings = {
          nixd = {
             pkgs = {
                expr = "import <nixpkgs> { }",
             },
             ["pkgs-stable"] = {
                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs-stable {}",
             },
             ["pkgs-unstable"] = {
                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs-unstable {}",
             },
             formatting = {
                command = { "nixfmt" },
             },
             options = nixd_lsp_config(),
          },
       },
      })
    '';
  };
}

{
  lib,
  pkgs,
  pkgs-unstable,
  isNixDarwin,
  nixDarwinSystemName,
  isNixos,
  nixosSystemName,
  homeManagerName,
  ...
}:
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

          if vim.g.is_darwin then
              opts.nix_darwin = {
                  expr = '(builtins.getFlake (builtins.toString ./.)).darwinConfigurations."${nixDarwinSystemName}".options'
              }
          end

          if vim.g.is_nixos then
              opts.nixos = {
                  expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations."${nixosSystemName}".options'
              }
          end

            opts.home_manager = {
                expr = '(builtins.getFlake (builtins.toString ./.)).homeConfigurations."${homeManagerName}".options'
            }

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

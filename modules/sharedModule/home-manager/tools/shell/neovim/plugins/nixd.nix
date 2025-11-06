{
  lib,
  pkgs,
  isNixDarwin,
  nixDarwinSystemName,
  isNixos,
  nixosSystemName,
  homeManagerName,
  ...
}:
{
  home.packages = with pkgs; [
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

      vim.lsp.config("nixd", {
       cmd = { "nixd" },
       settings = {
          nixd = {
             pkgs = {
                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs-unstable {}",
             },
             ["pkgs-stable"] = {
                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs-os {}",
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
      vim.lsp.enable("nixd")
    '';
  };
}

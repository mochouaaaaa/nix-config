{
  pkgs,
  isNixDarwin,
  nixDarwinSystemName,
  isNixos,
  nixosSystemName,
  homeManagerName,
  username,
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
              opts = {
                  nix_darwin = {
                      expr = '(builtins.getFlake (toString ./.)).darwinConfigurations."${nixDarwinSystemName}".options',
                  },
                  home_manager = {
                      expr = '(builtins.getFlake (toString ./.)).darwinConfigurations."${nixDarwinSystemName}".options.home-manager.users.value.${username}',
                  },
              }
          end

          if vim.g.is_nixos then
              opts = {
                  nixos = {
                      expr = '(builtins.getFlake (toString ./.)).nixosConfigurations."${nixosSystemName}".options',
                  },
                  home_manager = {
                      expr = '(builtins.getFlake (toString ./.)).nixosConfigurations."${nixosSystemName}".options.home-manager.users.value.${username}',
                  },
              }
          end

          if not vim.g.is_nixos and not vim.g.is_darwin then
              opts.home_manager = {
                  expr = '(builtins.getFlake (toString ./.)).homeConfigurations."${homeManagerName}".options',
              }
          end

          return opts
      end

      vim.lsp.config("nixd", {
       cmd = { "nixd" },
       settings = {
          nixd = {
             pkgs = {
                expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs {}",
             },
             ["pkgs-stable"] = {
                expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs-os {}",
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

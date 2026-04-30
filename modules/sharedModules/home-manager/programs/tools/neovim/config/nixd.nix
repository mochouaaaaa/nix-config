{
  pkgs,
  nixDarwinSystemName,
  nixosSystemName,
  homeManagerName,
  ...
}:
{
  programs.neovim = {
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
    initLua = ''
      local nixd_lsp_config = function()
          local opts = {}

          if vim.g.is_darwin then
              opts = {
                  nix_darwin = {
                      expr = '(builtins.getFlake (toString ./.)).darwinConfigurations."${nixDarwinSystemName}".options',
                  },
                  -- home_manager = {
                  --     expr = '(builtins.getFlake (toString ./.)).darwinConfigurations."${nixDarwinSystemName}".options.home-manager.users.type.getSubOptions []',
                  -- },
              }
          end

          if vim.g.is_nixos then
              opts = {
                  nixos = {
                      expr = '(builtins.getFlake (toString ./.)).nixosConfigurations."${nixosSystemName}".options',
                  },
                  -- home_manager = {
                  --     expr = '(builtins.getFlake (toString ./.)).nixosConfigurations."${nixosSystemName}".options.home-manager.users.type.getSubOptions []',
                  -- },
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
          filetypes = { "nix" },
          root_markers = { "flake.nix", "flake.lock", ".git" },
          settings = {
              nixd = {
                  pkgs = {
                      expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs {}",
                  },
                  ["pkgs-stable"] = {
                      expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs-stable {}",
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

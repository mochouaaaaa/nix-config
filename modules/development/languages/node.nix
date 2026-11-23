{
  flake.modules.homeManager."development.node" =
    { pkgs, ... }:
    {
      # npm owns the Node.js package as well as the user-level npmrc.
      # Use one Node.js version for both the runtime and npm CLI.
      programs = {
        pnpm = {
          enable = true;
        };
      };

      programs = {
        vscode = {
          profiles = {
            default = {
              extensions = with pkgs.vscode-extensions; [
                # js
                bradlc.vscode-tailwindcss
              ];
            };
          };
        };
      };

      programs.neovim = {
        withNodeJs = true;
        plugins = with pkgs.vimPlugins; [
          (nvim-treesitter.withPlugins (p: [
            p.javascript
            p.typescript
            p.astro
            p.tsx
            p.vue
            p.html
            p.css
          ]))
        ];
        extraPackages = with pkgs; [
          # js/ts
          vtsls
          typescript
          astro-language-server
          vue-language-server
        ];
        initLua = ''
          vim.lsp.config("vtsls", {
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
            },
          })

          vim.lsp.enable("vtsls")
        '';
      };

    };

  # Preserve global package-manager state only when installed through Home Manager.
  # Project-local Node.js runtimes are intentionally not inferred here.
  flake.modules.nixos.preservation =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages;
      pnpm = config.home-manager.users.${username}.programs.pnpm;
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.nodejs homePackages) [ ".npm" ]
        ++ lib.optionals (lib.elem pkgs.yarn homePackages) [ ".yarn" ]
        ++ lib.optionals pnpm.enable [ pnpm.pnpmHome ];
    };
}

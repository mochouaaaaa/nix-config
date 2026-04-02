{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    programs.neovim = {
      initLua = ''
        vim.filetype.add({
          pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
        })

        -- Hyprlang LSP
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = { "*.hl", "hypr*.conf" },
            callback = function(event)
                vim.lsp.start({
                    name = "hyprlang",
                    cmd = { "hyprls" },
                    root_dir = vim.fn.getcwd(),
                })
            end,
        })

      '';
      extraPackages = lib.mkBefore (
        with pkgs;
        [
          tree-sitter-grammars.tree-sitter-hyprlang
        ]
      );
    };

  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    programs.nixvim = {
      extraConfigLuaPost = ''
        vim.filetype.add({
          pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
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

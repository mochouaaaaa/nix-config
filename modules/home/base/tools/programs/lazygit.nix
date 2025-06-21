{ pkgs, ... }:
{
  programs =
    let
      shellAliases = {
        lazygit = ''lazygit --use-config-file="$HOME/.config/lazygit/config.yml"'';
      };
    in
    {
      zsh.shellAliases = shellAliases;
      bash.shellAliases = shellAliases;
      lazygit = {
        enable = true;
        package = pkgs.lazygit;
        settings = {
          gui.theme = {
            activeBorderColor = [
              "#89b4fa"
              "bold"
            ];
            inactiveBorderColor = [ "#a6adc8" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            cherryPickedCommitBgColor = [ "#45475a" ];
            cherryPickedCommitFgColor = [ "#89b4fa" ];
            unstagedChangesColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
          };
          gui.authorColors = {
            "*" = "#b4befe";
          };
        };
      };
    };
}

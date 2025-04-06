{ pkgs, ... }:
{
  programs = {
    vscode = {
      enable = true;
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles = {
        default = {
          userSettings = { };
          extensions = with pkgs.vscode-marketplace; [ ];
        };
      };
    };
  };
}

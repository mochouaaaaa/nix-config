{ pkgs, ... }:
{
  imports = [ ./plugins ];

  programs = {
    vscode = {
      enable = true;
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles = {
        default = {
          userSettings = { };
          extensions = with pkgs.vscode-extensions; [
            usernamehw.errorlens
            eamodio.gitlens
            mhutchie.git-graph
            vspacecode.whichkey

            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode-remote.vscode-remote-extensionpack
          ];
        };
      };
    };
  };
}

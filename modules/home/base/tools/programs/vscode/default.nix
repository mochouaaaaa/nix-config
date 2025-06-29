{ pkgs, self, ... }:
{
  imports = [ self.importModule' ./. ];

  programs = {
    vscode = {
      enable = true;
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles = {
        "${self.myvars.username}" = {
          extensions = with pkgs.vscode-extensions; [
            ms-ceintl.vscode-language-pack-zh-hans
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

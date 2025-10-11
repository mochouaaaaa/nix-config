{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  imports = lib.importModule' ./.;

  config = {

    programs = lib.mkIf (!config.programs.wsl.enable) {
      vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles = {
          "${username}" = {
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

  };
}

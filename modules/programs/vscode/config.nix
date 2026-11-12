{
  flake.modules.homeManager."programs.vscode" = { pkgs, ... }: {

    programs = {
      vscode = {
        enable = true;
        mutableExtensionsDir = true;
        profiles = {
          default = {
            extensions = with pkgs.vscode-extensions; [
              ms-ceintl.vscode-language-pack-zh-hans
              usernamehw.errorlens
              eamodio.gitlens
              mhutchie.git-graph

              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-ssh-edit
              ms-vscode-remote.vscode-remote-extensionpack
            ];
          };
        };
      };
    };

  };

  # Install VS Code with Homebrew on macOS; Home Manager only manages its config.
  flake.modules.homeManager.darwin = {
    programs.vscode.package = null;
  };

  flake.modules.darwin.programs = {
    homebrew.casks = [ "visual-studio-code" ];
  };
}

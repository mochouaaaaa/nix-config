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

  # Install VS Code with Homebrew on Intel macOS; Home Manager only manages its config.
  flake.modules.homeManager.darwin =
    { lib, pkgs, ... }:
    lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") {
      programs.vscode.package = null;
    };

  flake.modules.darwin.programs =
    { lib, pkgs, ... }:
    lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") {
      homebrew.casks = [ "visual-studio-code" ];
    };
}

{
  # Shared VS Code application settings and baseline extensions.
  flake.aspects.editors.provides.vscode.homeManager =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = true;

        profiles.default.extensions = with pkgs.vscode-extensions; [
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
}

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

  # The official VS Code 1.129+ macOS archive stores native modules in
  # node_modules.asar.unpacked. Keep this workaround limited to Intel macOS:
  # newer nixpkgs versions no longer provide x86_64-darwin VS Code support.
  flake.modules.homeManager.darwin =
    { lib, pkgs, ... }:
    lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") {
      programs.vscode.package = pkgs.vscode.overrideAttrs (old:
        let
          oldRipgrepPath = "Contents/Resources/app/node_modules/@vscode/ripgrep-universal/bin/darwin-x64/rg";
          newRipgrepPath = "Contents/Resources/app/node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/darwin-x64/rg";
          postPatch = old.postPatch or "";
        in
        assert builtins.match ".*${oldRipgrepPath}.*" postPatch != null;
        {
          postPatch = builtins.replaceStrings
            [ oldRipgrepPath ]
            [ newRipgrepPath ]
            postPatch;
        });
    };
}

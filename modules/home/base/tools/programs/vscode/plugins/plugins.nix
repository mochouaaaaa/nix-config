{
  pkgs,
  lib,
  self,
  ...
}:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
in
{
  programs = {
    vscode = {
      profiles = {
        "${self.myvars.username}" = {
          extensions = lib.mkAfter (
            with pkgs.vscode-extensions;
            [
              # base extensions
              formulahendry.code-runner
              ms-azuretools.vscode-docker
              ms-vscode-remote.remote-containers
              redhat.vscode-yaml
              tamasfe.even-better-toml

              # theme
              vscode-icons-team.vscode-icons
              zhuangtongfa.material-theme
              # (buildVscodeMarketplaceExtension {
              #   mktplcRef = {
              #     name = "One Dark Pro";
              #     publisher = "binaryify";
              #     version = ".19.0";
              #     # hash = "";
              #   };
              #   meta = {
              #     license = lib.licenses.mit;
              #   };
              # })

              # shell
              timonwong.shellcheck
              foxundermoon.shell-format

              # C / C++
              twxs.cmake
              ms-vscode.cmake-tools

              # nix
              jnoortheen.nix-ide
              bbenoist.nix
              brettm12345.nixfmt-vscode

              # lua
              sumneko.lua

              # python
              ms-python.python
              # pylyzer.pylyzer
              ms-python.pylint
              ms-python.debugpy
              ms-python.vscode-pylance
              batisteo.vscode-django

              # golang
              golang.go

              # js
              bradlc.vscode-tailwindcss
            ]
          );
        };
      };
    };
  };
}

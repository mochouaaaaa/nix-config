{
  pkgs,
  lib,
  username,
  ...
}:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

in
{
  programs = {
    vscode = {
      profiles = {
        "${username}" = {
          extensions = lib.mkAfter (
            with pkgs.vscode-extensions;
            [
              # base extensions
              formulahendry.code-runner
              ms-azuretools.vscode-docker
              ms-vscode-remote.remote-containers
              redhat.vscode-yaml
              tamasfe.even-better-toml

              #ai
              # FittenTech.Fitten-Code
              (buildVscodeMarketplaceExtension {
                mktplcRef = {
                  name = "Fitten-Code";
                  publisher = "FittenTech";
                  version = "0.10.149";
                  hash = "sha256-3TTpOn6t5gOqYf3TcXNzk57mHk2vaERvmBdHmkxQuXc=";
                };
              })

              # asvetliakov.vscode-neovim

              # theme
              # Vogadero.auto-theme
              vscode-icons-team.vscode-icons
              zhuangtongfa.material-theme
              # (buildVscodeMarketplaceExtension {
              #   mktplcRef = {
              #     name = "auto-theme";
              #     publisher = "Vogadero";
              #     version = "0.1.0";
              #     hash = "sha256-e5ySgUdHpkekYcZbtjFrzws/foaerKed0nNEVBEx0Ic=";
              #   };
              #   meta = {
              #     license = lib.licenses.mit;
              #   };
              # })

              # shell
              timonwong.shellcheck
              foxundermoon.shell-format

              # C / C++
              ms-vscode.cmake-tools
              ms-vscode.cpptools-extension-pack

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

              # just
              nefrob.vscode-just-syntax
            ]
          );
        };
      };
    };
  };
}

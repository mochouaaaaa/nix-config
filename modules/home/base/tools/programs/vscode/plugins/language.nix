{ pkgs, lib, ... }:
{
  programs = {
    vscode = {
      profiles = {
        default = {
          extensions = lib.mkAfter (
            with pkgs.vscode-extensions;
            [
              # base extensions
              formulahendry.code-runner
              ms-azuretools.vscode-docker

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

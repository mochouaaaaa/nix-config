{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
  baseFinditfaster = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "find-it-faster";
      publisher = "TomRijndorp";
      version = "0.0.39";
      hash = "sha256-Rr1EKYSYmY52FfG4ClSQyikr0fd4cFKjphNxpzhiraw=";
    };
  };

  finditfaster = baseFinditfaster.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cd $out/share/vscode/extensions/TomRijndorp.find-it-faster
      patchShebangs .
    '';
  });
in
{
  programs = {
    vscode = {
      profiles = {
        default = {
          keybindings = [
            # {
            #   key = "meta+f";
            #   command = "find-it-faster.findFiles";
            # }
            # {
            #   key = "meta+shift+f";
            #   command = "find-it-faster.findWithinFiles";
            # }
          ];
          extensions = with pkgs.vscode-extensions; [
            # base extensions
            formulahendry.code-runner
            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-containers
            redhat.vscode-yaml
            tamasfe.even-better-toml
            k--kato.intellij-idea-keybindings
            finditfaster
            mkhl.direnv
            asvetliakov.vscode-neovim

            (buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "git-commit-plugin";
                publisher = "redjue";
                version = "1.5.0";
                hash = "sha256-fOdeUuB4jFL0LvGsLcjz5EQslD8jRRGslbumMo3cZCs=";
              };
            })

            #ai FittenTech.Fitten-Code
            # FittenTech.Fitten-Code
            (buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "Fitten-Code";
                publisher = "FittenTech";
                version = "1.0.3";
                hash = "sha256-BPkCKefKVqTl4VF0/Dct52j2kz0K3bw3BuLOLMkkMII=";
              };
            })

            # asvetliakov.vscode-neovim

            # theme
            # Vogadero.auto-theme
            # vscode-icons-team.vscode-icons
            zhuangtongfa.material-theme

            # shell
            timonwong.shellcheck
            foxundermoon.shell-format

            # C / C++
            ms-vscode.cmake-tools
            ms-vscode.cpptools-extension-pack

            (buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "qt-qml";
                publisher = "TheQtCompany";
                version = "1.7.0";
                hash = "sha256-QjfvZIcE4LcJU93YiYN/zykEluHtR7zVOwYiPL0k+cQ=";
              };
              meta = {
                license = lib.licenses.gpl3Plus;
              };
            })

            # nix
            jnoortheen.nix-ide
            bbenoist.nix
            brettm12345.nixfmt-vscode

            # lua
            sumneko.lua

            # python
            ms-python.python
            ms-python.pylint
            ms-python.debugpy
            batisteo.vscode-django
            (buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "ty";
                publisher = "astral-sh";
                version = "2025.76.0";
                hash = "sha256-rbP4ZdWO4kHvcKTR1tgBomzYj9yAagSGjZCPnHNIqZ0=";
              };
            })

            # golang
            golang.go

            # js
            bradlc.vscode-tailwindcss

            # just
            nefrob.vscode-just-syntax
          ];
        };
      };
    };
  };
}

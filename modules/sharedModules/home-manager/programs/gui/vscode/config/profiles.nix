{
  config,
  isNixDarwin,
  nixDarwinSystemName,
  isNixos,
  nixosSystemName,
  homeManagerName,
  username,
  ...
}:
let

  homeExpr =
    if isNixos then
      "(builtins.getFlake (toString ./.)).nixosConfigurations.\"${nixosSystemName}\".options.home-manager.users.type.getSubOptions []"
    else if isNixDarwin then
      "(builtins.getFlake (toString ./.)).darwinConfigurations.\"${nixDarwinSystemName}\".options.home-manager.users.type.getSubOptions []"
    else
      "(builtins.getFlake (toString ./.)).homeConfigurations.\"${homeManagerName}\".options";

in
{

  programs = {
    vscode.profiles = {
      default = {
        userSettings = {
          # =========== language
          "python.languageServer" = "None";
          "[nix]" = {
            "editor.tabSize" = 4;
            "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
          };
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
              "pkgs" = {
                "expr" = "import <nixpkgs> { }";
              };
              "pkgs-stable" = {
                "expr" = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs-os {}";
              };
              "pkgs-unstable" = {
                "expr" = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs {}";
              };
              "options" = {
                "nixos" = {
                  "expr" =
                    "(builtins.getFlake (toString ./.)).nixosConfigurations.\"${nixDarwinSystemName}\".options";
                };
                "home-manager" = {
                  "expr" = "${homeExpr}";
                };
                "nix-darwin" = {
                  "expr" = "(builtins.getFlake (toString ./.)).darwinConfigurations.\"${nixosSystemName}\".options";
                };
              };
            };
          };
          "nix.hiddenLanguageServerErrors" = [
            "textDocument/definition"
          ];

          # ================= Git
          "git.enableCommitSigning" = false;
          "git.enableSmartCommit" = false;
          "GitCommitPlugin.ShowEmoji" = false;

          # ================= 插件配置
          "fittencode.languagePreference.displayPreference" = "zh-cn";
          "fittencode.languagePreference.commentPreference" = "zh-cn";
          "find-it-faster.general.useTerminalInEditor" = false;
          "fittencode.agent.enableFunctionCall" = true;
          "fittencode.Unit Test Framework.Go" = "gotest";

          # ================== files
          "files.watcherExclude" = {
            "**/.git/objects/**" = true;
            "**/.git/subtree-cache/**" = true;
            "**/node_modules/*/**" = true;
            "**/tmp/**" = true;
            "**/bower_components/**" = true;
          };
          "files.exclude" = {
            "**/.git" = true;
            "**/.svn" = true;
            "**/.hg" = true;
            "**/.DS_Store" = true;
            "**/Thumbs.db" = true;
            "**/node_modules" = true;
            "**/bower_components" = true;
            "**/*.code-search" = true;
            "**/.direnv" = true;
            "**/.devenv" = true;
            "**/.venv" = true;
            "**/.Trash-1000" = true;
          };
          "explorer.excludeGitIgnore" = false;
          "search.useIgnoreFiles" = true;

          # UI
          "workbench.sideBar.location" = "right";
          "workbench.iconTheme" = "vscode-icons";
          "workbench.colorTheme" = "One Dark Pro";
          "workbench.preferredLightColorTheme" = "Default Light+";
          "workbench.preferredDarkColorTheme" = "One Dark Pro";
          "workbench.tree.indent" = 22;
          "workbench.list.smoothScrolling" = true;
          "workbench.tree.renderIndentGuides" = "always";

          #============= window
          "window.autoDetectColorScheme" = true;
          "window.zoomLevel" = 1.6;

          # =================== editor
          # // ctrl+滚轮调整字体大小
          "editor.emptySelectionClipboard" = false;
          "editor.formatOnPaste" = false;
          "editor.mouseWheelZoom" = true;
          "editor.tabSize" = 4;
          "editor.lineHeight" = 24;
          "editor.fontSize" = 18;
          "editor.fontFamily" = "${config.profiles.fonts.default}";
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = "explicit";
          };
          "editor.wordWrap" = "on";
          "editor.autoIndentOnPaste" = true;
          "editor.codeLensFontFamily" = "${config.profiles.fonts.default}";
          "editor.defaultFormatter" = "vscode.json-language-features";
          "editor.formatOnSave" = true;
          "editor.formatOnType" = true;
          "editor.formatOnSaveMode" = "file";
          "editor.tokenColorCustomizations" = {
            "textMateRules" = [
              {
                "name" = "italic font";
                "scope" = [
                  "comment"
                  "keyword"
                  "storage"
                  "keyword.control"
                  "keyword.control.from"
                  "keyword.control.flow"
                  "keyword.operator.new"
                  "keyword.control.import"
                  "keyword.control.export"
                  "keyword.control.default"
                  "keyword.control.trycatch"
                  "keyword.control.conditional"
                  "storage.type"
                  "storage.type.class"
                  "storage.modifier.tsx"
                  "storage.type.function"
                  "storage.modifier.async"
                  "variable.language"
                  "variable.language.this"
                  "variable.language.super"
                  "meta.class"
                  "meta.var.expr"
                  "constant.language.null"
                  "support.type.primitive"
                  "entity.name.method.js"
                  "entity.other.attribute-name"
                  "punctuation.definition.comment"
                  "text.html.basic entity.other.attribute-name"
                  "tag.decorator.js entity.name.tag.js"
                  "tag.decorator.js punctuation.definition.tag.js"
                  "source.js constant.other.object.key.js string.unquoted.label.js"
                ];
                "settings" = {
                  "fontStyle" = "italic";
                };
              }
            ];
            # debug
            "debug.console.fontFamily" = "${config.profiles.fonts.default}";
            "debug.console.fontSize" = 15;
            "debug.console.historySuggestions" = false;
          };

        };

      };
    };
  };
}

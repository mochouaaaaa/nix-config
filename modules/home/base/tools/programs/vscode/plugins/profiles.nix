{ self, ... }:
{
  programs = {
    vscode.profiles = {
      "${self.myvars.username}" = {
        userSettings = {
          "[nix]"."editor.tabSize" = 4;

          "files.watcherExclude" = {
            "**/.git/objects/**" = true;
            "**/.git/subtree-cache/**" = true;
            "**/node_modules/*/**" = true;
            "**/tmp/**" = true;
            "**/bower_components/**" = true;
          };

          # theme
          "workbench.iconTheme" = "vscode-icons";
          "workbench.colorTheme" = "One Dark Pro";
          # "workbench.preferredDarkColorTheme" = "One Dark Pro";
          # "workbench.preferredLightColorTheme" = "One Dark Pro";
          "autoTheme.mode" = "auto";
          "autoTheme.dayTheme" = "Default Light+";
          "autoTheme.nightTheme" = "One Dark Pro";
          "autoTheme.manualLocation" = {
            "lat" = 39.9042;
            "lng" = 116.4074;
          };

          # // ctrl+滚轮调整字体大小
          "editor.mouseWheelZoom" = false;
          # // 一个制表符等于的空格数。
          "editor.tabSize" = 4;
          "editor.lineHeight" = 24;
          # // 控制字体大小(像素)。
          "editor.fontSize" = 17;
          # // 控制字体系列。
          "editor.fontFamily" = "Monaco Nerd Font Mono";
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = "explicit";
          };
          "editor.formatOnSave" = true;
          "editor.formatOnType" = true;
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
          };
          # debug
          "debug.console.fontFamily" = "Monaco";
          "debug.console.fontSize" = 15;
          "debug.console.historySuggestions" = false;
        };
      };
    };
  };
}

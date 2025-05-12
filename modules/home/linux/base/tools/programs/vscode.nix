{
  self,
  lib,
  pkgs,
  config,
  isNixos,
  ...
}:
let
  cfg = config.modules.packages.vscode;
  cfgKeymaps = config.keymaps;
in
{
  options.modules.packages.vscode = {
    commandLineArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "--locale=zh-cn"
        "--no-sandbox"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
      ];
      description = "Additional command line arguments to pass to the VSCode binary.";
    };
  };

  config = {
    programs = {
      vscode = {
        # let vscode sync and update its configuration & extensions across devices; using github account.
        profiles."${self.myvars.username}" = {
          userSettings =
            { }
            // lib.mkIf isNixos {
              "nix.enableLanguageServer" = true;
              "nix.serverPath" = "nil";
              "nix.serverSettings" = {
                "nil" = {
                  # "diagnostics"= {
                  #  "ignored"= ["unused_binding"; "unused_with"];
                  # };
                  "formatting" = {
                    "command" = [ "nixfmt" ];
                  };
                };
                "nixd" = {
                  "formatting" = {
                    "command" = [ "nixfmt" ];
                  };
                  "options" = {
                    "nixos" = {
                      "expr" =
                        "(builtins.getFlake \"${config.home.homeDirectory}/nix/flake\").nixosConfigurations.nixos.options";
                    };
                    "home-manager" = {
                      "expr" =
                        "(builtins.getFlake \"${config.home.homeDirectory}/nix/flake\").homeConfigurations.home-manager.options";
                    };
                    "nix-darwin" = {
                      "expr" =
                        ''(builtins.getFlake \"''${workspaceFolder}${config.home.homeDirectory}/nix/flake\").darwinConfigurations.macos.options'';
                    };
                  };
                };
              };
            };
          keybindings = lib.mkAfter [
            {
              key = "${cfgKeymaps.Super}+f";
              command = "actions.find";
              when = "editorFocus || editorIsOpen";
            }
            {
              key = "ctrl+f";
              command = "-actions.find";
              when = "editorFocus || editorIsOpen";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "notebook.find";
              when = "notebookEditorFocused && !editorFocus && activeEditor == 'workbench.editor.interactive' || notebookEditorFocused && !editorFocus && activeEditor == 'workbench.editor.notebook'";
            }
            {
              key = "ctrl+f";
              command = "-notebook.find";
              when = "notebookEditorFocused && !editorFocus && activeEditor == 'workbench.editor.interactive' || notebookEditorFocused && !editorFocus && activeEditor == 'workbench.editor.notebook'";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "settings.action.search";
              when = "inSettingsEditor";
            }
            {
              key = "ctrl+f";
              command = "-settings.action.search";
              when = "inSettingsEditor";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "workbench.action.terminal.focusFind";
              when = "terminalFindFocused && terminalHasBeenCreated || terminalFindFocused && terminalProcessSupported || terminalFocusInAny && terminalHasBeenCreated || terminalFocusInAny && terminalProcessSupported";
            }
            {
              key = "ctrl+f";
              command = "-workbench.action.terminal.focusFind";
              when = "terminalFindFocused && terminalHasBeenCreated || terminalFindFocused && terminalProcessSupported || terminalFocusInAny && terminalHasBeenCreated || terminalFocusInAny && terminalProcessSupported";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "commentsFocusFilter";
              when = "focusedView == 'workbench.panel.comments'";
            }
            {
              key = "ctrl+f";
              command = "-commentsFocusFilter";
              when = "focusedView == 'workbench.panel.comments'";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "editor.action.extensioneditor.showfind";
              when = "!editorFocus && activeEditor == 'workbench.editor.extension'";
            }
            {
              key = "ctrl+f";
              command = "-editor.action.extensioneditor.showfind";
              when = "!editorFocus && activeEditor == 'workbench.editor.extension'";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "editor.action.webvieweditor.showFind";
              when = "webviewFindWidgetEnabled && !editorFocus && activeEditor == 'WebviewEditor'";
            }
            {
              key = "ctrl+f";
              command = "-editor.action.webvieweditor.showFind";
              when = "webviewFindWidgetEnabled && !editorFocus && activeEditor == 'WebviewEditor'";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "keybindings.editor.searchKeybindings";
              when = "inKeybindings";
            }
            {
              key = "ctrl+f";
              command = "-keybindings.editor.searchKeybindings";
              when = "inKeybindings";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "problems.action.focusFilter";
              when = "focusedView == 'workbench.panel.markers.view'";
            }
            {
              key = "ctrl+f";
              command = "-problems.action.focusFilter";
              when = "focusedView == 'workbench.panel.markers.view'";
            }
            {
              key = "${cfgKeymaps.Super}+f";
              command = "repl.action.filter";
              when = "inDebugRepl && textInputFocus";
            }
            {
              key = "ctrl+f";
              command = "-repl.action.filter";
              when = "inDebugRepl && textInputFocus";
            }
            {
              key = "alt+${cfgKeymaps.Super}+f";
              command = "repl.action.find";
              when = "inDebugRepl || inDebugRepl && focusedView == 'workbench.panel.repl.view'";
            }
            {
              key = "ctrl+alt+f";
              command = "-repl.action.find";
              when = "inDebugRepl || inDebugRepl && focusedView == 'workbench.panel.repl.view'";
            }
            {
              key = "alt+${cfgKeymaps.Super}+f";
              command = "list.find.replInputFocus";
              when = "view == 'workbench.panel.repl.view'";
            }
            {
              key = "ctrl+alt+f";
              command = "-list.find.replInputFocus";
              when = "view == 'workbench.panel.repl.view'";
            }
            {
              key = "alt+${cfgKeymaps.Super}+f";
              command = "list.find";
              when = "listFocus && listSupportsFind";
            }
            {
              key = "ctrl+alt+f";
              command = "-list.find";
              when = "listFocus && listSupportsFind";
            }
            {
              key = "shift+${cfgKeymaps.Super}+f";
              command = "workbench.view.search";
              when = "workbench.view.search.active && neverMatch =~ /doesNotMatch/";
            }
            {
              key = "ctrl+shift+f";
              command = "-workbench.view.search";
              when = "workbench.view.search.active && neverMatch =~ /doesNotMatch/";
            }
            {
              key = "shift+${cfgKeymaps.Super}+f";
              command = "workbench.action.terminal.searchWorkspace";
              when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
            }
            {
              key = "ctrl+shift+f";
              command = "-workbench.action.terminal.searchWorkspace";
              when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
            }
            {
              key = "shift+${cfgKeymaps.Super}+f";
              command = "workbench.action.findInFiles";
            }
            {
              key = "ctrl+shift+f";
              command = "-workbench.action.findInFiles";
            }
            {
              key = "c+x";
              command = "editor.action.clipboardCutAction";
            }
            {
              key = "ctrl+x";
              command = "-editor.action.clipboardCutAction";
            }
            {
              key = "${cfgKeymaps.Super}+v";
              command = "editor.action.clipboardPasteAction";
            }
            {
              key = "ctrl+v";
              command = "-editor.action.clipboardPasteAction";
            }
            {
              key = "${cfgKeymaps.Super}+v";
              command = "filesExplorer.paste";
              when = "filesExplorerFocus && foldersViewVisible && !explorerResourceReadonly && !inputFocus";
            }
            {
              key = "ctrl+v";
              command = "-filesExplorer.paste";
              when = "filesExplorerFocus && foldersViewVisible && !explorerResourceReadonly && !inputFocus";
            }
            {
              key = "${cfgKeymaps.Super}+c";
              command = "editor.action.clipboardCopyAction";
            }
            {
              key = "ctrl+c";
              command = "-editor.action.clipboardCopyAction";
            }
            {
              key = "${cfgKeymaps.Super}+c";
              command = "filesExplorer.copy";
              when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !inputFocus";
            }
            {
              key = "ctrl+c";
              command = "-filesExplorer.copy";
              when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !inputFocus";
            }
            {
              key = "${cfgKeymaps.Super}+z";
              command = "undo";
            }
            {
              key = "ctrl+z";
              command = "-undo";
            }
            {
              key = "${cfgKeymaps.Super}+z";
              command = "inlineChat.unstash";
              when = "inlineChatHasStashedSession && !editorReadonly";
            }
            {
              key = "ctrl+z";
              command = "-inlineChat.unstash";
              when = "inlineChatHasStashedSession && !editorReadonly";
            }
            {
              key = "${cfgKeymaps.Super}+s";
              command = "workbench.action.files.save";
            }
            {
              key = "ctrl+s";
              command = "-workbench.action.files.save";
            }
            {
              key = "${cfgKeymaps.Super}+a";
              command = "notebook.cell.output.selectAll";
              when = "notebookEditorFocused && notebookOutputFocused";
            }
            {
              key = "ctrl+a";
              command = "-notebook.cell.output.selectAll";
              when = "notebookEditorFocused && notebookOutputFocused";
            }
            {
              key = "${cfgKeymaps.Super}+a";
              command = "editor.action.selectAll";
            }
            {
              key = "ctrl+a";
              command = "-editor.action.selectAll";
            }
            {
              key = "${cfgKeymaps.Super}+a";
              command = "list.selectAll";
              when = "listFocus && listSupportsMultiselect && !inputFocus && !treestickyScrollFocused";
            }
            {
              key = "ctrl+a";
              command = "-list.selectAll";
              when = "listFocus && listSupportsMultiselect && !inputFocus && !treestickyScrollFocused";
            }
            {
              key = "${cfgKeymaps.Super}+w";
              command = "workbench.action.closeActiveEditor";
            }
            {
              key = "ctrl+w";
              command = "-workbench.action.closeActiveEditor";
            }
            {
              key = "${cfgKeymaps.Super}+w";
              command = "workbench.action.closeGroup";
              when = "activeEditorGroupEmpty && multipleEditorGroups";
            }
            {
              key = "ctrl+w";
              command = "-workbench.action.closeGroup";
              when = "activeEditorGroupEmpty && multipleEditorGroups";
            }
            {
              key = "shift+${cfgKeymaps.Super}+w";
              command = "workbench.action.closeEditorsInGroup";
            }
            {
              key = "ctrl+k w";
              command = "-workbench.action.closeEditorsInGroup";
            }
            {
              key = "${cfgKeymaps.Super}+w";
              command = "workbench.action.terminal.killEditor";
              when = "terminalEditorFocus && terminalFocus && terminalHasBeenCreated || terminalEditorFocus && terminalFocus && terminalProcessSupported";
            }
            {
              key = "ctrl+w";
              command = "-workbench.action.terminal.killEditor";
              when = "terminalEditorFocus && terminalFocus && terminalHasBeenCreated || terminalEditorFocus && terminalFocus && terminalProcessSupported";
            }
            {
              key = "shift+${cfgKeymaps.Super}+w";
              command = "workbench.action.closeWindow";
            }
            {
              key = "ctrl+shift+w";
              command = "-workbench.action.closeWindow";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "workbench.action.chat.editing.attachContext";
              when = "inChatInput && inUnifiedChat || inChatInput && chatLocation == 'editing-session' || inChatInput && inUnifiedChat && chatLocation == 'editing-session'";
            }
            {
              key = "ctrl+/";
              command = "-workbench.action.chat.editing.attachContext";
              when = "inChatInput && inUnifiedChat || inChatInput && chatLocation == 'editing-session' || inChatInput && inUnifiedChat && chatLocation == 'editing-session'";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "workbench.action.terminal.sendSequence";
              when = "terminalFocus";
            }
            {
              key = "ctrl+/";
              command = "-workbench.action.terminal.sendSequence";
              when = "terminalFocus";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "workbench.action.chat.attachContext";
              when = "inChatInput && !inUnifiedChat && chatLocation == 'panel' && chatLocation != 'editing-session'";
            }
            {
              key = "ctrl+/";
              command = "-workbench.action.chat.attachContext";
              when = "inChatInput && !inUnifiedChat && chatLocation == 'panel' && chatLocation != 'editing-session'";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "toggleExplainMode";
              when = "suggestWidgetVisible";
            }
            {
              key = "ctrl+/";
              command = "-toggleExplainMode";
              when = "suggestWidgetVisible";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "terminalSuggestToggleExplainMode";
              when = "terminalFocus && terminalHasBeenCreated && terminalIsOpen && terminalSuggestWidgetVisible || terminalFocus && terminalIsOpen && terminalProcessSupported && terminalSuggestWidgetVisible";
            }
            {
              key = "ctrl+/";
              command = "-terminalSuggestToggleExplainMode";
              when = "terminalFocus && terminalHasBeenCreated && terminalIsOpen && terminalSuggestWidgetVisible || terminalFocus && terminalIsOpen && terminalProcessSupported && terminalSuggestWidgetVisible";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "editor.action.commentLine";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "ctrl+/";
              command = "-editor.action.commentLine";
              when = "editorTextFocus && !editorReadonly";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "notebook.commentSelectedCells";
              when = "notebookEditable && notebookEditorFocused && !inputFocus";
            }
            {
              key = "ctrl+/";
              command = "-notebook.commentSelectedCells";
              when = "notebookEditable && notebookEditorFocused && !inputFocus";
            }
            {
              key = "${cfgKeymaps.Super}+/";
              command = "editor.action.accessibleViewAcceptInlineCompletion";
              when = "accessibleViewIsShown && accessibleViewCurrentProviderId == 'inlineCompletions'";
            }
            {
              key = "ctrl+/";
              command = "-editor.action.accessibleViewAcceptInlineCompletion";
              when = "accessibleViewIsShown && accessibleViewCurrentProviderId == 'inlineCompletions'";
            }
          ];
        };
        package = pkgs.vscode.override {
          commandLineArgs = cfg.commandLineArgs;
        };
      };
    };

    modules.xdg-mime.editors = lib.mkAfter [
      "code.desktop"
      "code-insiders.desktop"
    ];
  };
}

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
                      "expr" = "(builtins.getFlake \"/absolute/path/to/flake\").nixosConfigurations.<name>.options";
                    };
                    "home-manager" = {
                      "expr" = "(builtins.getFlake \"/absolute/path/to/flake\").homeConfigurations.<name>.options";
                    };
                    "nix-darwin" = {
                      "expr" =
                        ''(builtins.getFlake \"''${workspaceFolder}/path/to/flake\").darwinConfigurations.<name>.options'';
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
              key = "${cfgKeymaps.Super}+x";
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

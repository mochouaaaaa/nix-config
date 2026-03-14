{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    programs = {
      zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "python"
          "ty"
          "golangci-lint"
        ];
        extraPackages = with pkgs; [
          nixd
        ];
        userSettings = {
          vim_mode = false;
          autosave = "after_delay";
          theme = {
            mode = "system";
          };

          ui_font_size = 18;
          buffer_font_size = 18;
          ui_font_family = "${config.profiles.fonts.default}";
          buffer_font_family = "${config.profiles.fonts.default}";

          restore_on_startup = "last_session";
          cursor_shape = "block"; # 光标样式

          which_key = {
            enabled = true;
          };

          languages = {
            Python = {
              language_servers = [
                "ty"
                "!basedpyright"
              ];
            };
          };
        };
        # userKeymaps = [
        #   {
        #     bindings = {
        #       cmd-t = "workspace::NewTerminal";
        #       "/" = "editor::find";
        #       "space |" = "split-panel-right";
        #       "space _" = "split-panel-down";
        #       cmd-h = "focus-left-panel";
        #       cmd-j = "focus-down-panel";
        #       cmd-k = "focus-up-panel";
        #       cmd-l = "focus-right-panel";
        #       cmd-w = "pane::CloseActiveItem";
        #       cmd-e = "workspace::ToggleLeftDock";
        #       cmd-f = "file_finder::Toggle";
        #       cmd-shitf-f = "pane::deploy_search";
        #       cmd-ctrl-j = "pane::SplitHorizontal";
        #       cmd-ctrl-l = "pane::SplitVertical";
        #       "cmd-/" = "workspace::ToggleBottomDock";
        #     };
        #   }
        # ];
      };
    };

  };
}

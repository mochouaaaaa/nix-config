{ pkgs, ... }:
{
  programs = {
    zed-editor = {
      enable = false;
      extensions = [
        "nix"
        "python"
      ];
      extraPackages = with pkgs; [
        nixd
      ];
      userSettings = {
        base_keymap = "JetBrains";
        vim_mode = true;
        autosave = "after_delay";

        ui_font_size = 16;
        buffer_font_size = 16;
        buffer_font_family = "Monaco Nerd Font";

        restore_on_startup = "last_session";

        cursor_shape = "block"; # 光标样式
      };
      userKeymaps = [
        {
          bindings = {
            cmd-t = "workspace::NewTerminal";
            "/" = "editor::find";
            "space |" = "split-panel-right";
            "space _" = "split-panel-down";
            cmd-h = "focus-left-panel";
            cmd-j = "focus-down-panel";
            cmd-k = "focus-up-panel";
            cmd-l = "focus-right-panel";
            cmd-w = "pane::close";
            cmd-e = "project_panel::toggle";
            cmd-f = "file_finder::Toggle";
            cmd-shitf-f = "pane::deploy_search";
          };
        }
      ];
    };
  };
}

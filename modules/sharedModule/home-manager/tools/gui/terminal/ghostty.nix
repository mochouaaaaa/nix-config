{ config, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 16;
      font-family = "Monaco Nerd Font";

      theme = "noctalia";
      window-theme = "auto";

      background-opacity = 0.78;
      background-blur = true;
      keybind = [
        "performable:super+c=copy_to_clipboard"
        "performable:super+v=paste_from_clipboard"
        "performable:super+shift+v=paste_from_selection"
        "super+equal=increase_font_size:1"
        "super+minus=decrease_font_size:1"
        "super+0=reset_font_size"

        "super+w=close_surface"
        "super+t=new_tab"
      ];
    };
    clearDefaultKeybinds = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    systemd.enable = true;
  };
}

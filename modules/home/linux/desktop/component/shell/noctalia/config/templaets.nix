{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.noctalia-shell;
  cfgDesktop = config.profiles.desktop;
in
{

  config = lib.mkIf (cfg.enable) {

    programs.noctalia-shell.settings = {
      templates = {
        activeTemplates = [
          {
            enabled = true;
            id = "gtk";
          }
          {
            enabled = true;
            id = "qt";
          }
          {
            enabled = true;
            id = "kcolorscheme";
          }
          {
            enabled = config.programs.kitty.enable;
            id = "kitty";
          }
          {
            enabled = true;
            id = "pywalfox";
          }
          {
            enabled = true;
            id = "vicinae";
          }
          {
            enabled = config.programs.vscode.enable;
            id = "code";
          }
          {
            enabled = true;
            id = "telegram";
          }
          {
            enabled = config.programs.cava.enable;
            id = "cava";
          }
          {
            enabled = config.programs.yazi.enable;
            id = "yazi";
          }
          {
            enabled = config.programs.btop.enable;
            id = "btop";
          }
          {
            enabled = cfgDesktop.hyprland.enable;
            id = "hyprland";
          }
          {
            enabled = cfgDesktop.niri.enable;
            id = "niri";
          }
          {
            enabled = config.programs.alacritty.enable;
            id = "alacritty";
          }
          {
            enabled = config.programs.wezterm.enable;
            id = "wezterm";
          }
          {
            enabled = config.programs.ghostty.enable;
            id = "ghostty";
          }
          {
            enabled = config.programs.zed-editor.enable;
            id = "zed";
          }
        ];
        enableUserTheming = true;
      };

    };
  };
}

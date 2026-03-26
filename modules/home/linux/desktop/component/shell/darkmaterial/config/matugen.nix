{ lib, config, ... }:
let
  cfg = config.programs.dank-material-shell;
in
{

  config = lib.mkIf cfg.enable {
    programs.dank-material-shell = {
      settings = lib.mkDefaultRecursive {
        matugenTemplateGtk = true;
        matugenTemplateNiri = false;
        matugenTemplateHyprland = false;
        matugenTemplateMangowc = false;
        matugenTemplateQt5ct = true;
        matugenTemplateQt6ct = true;
        matugenTemplateFirefox = config.programs.firefox.enable;
        matugenTemplatePywalfox = config.programs.firefox.enable;
        matugenTemplateZenBrowser = config.programs.zen-browser.enable;
        matugenTemplateVesktop = config.programs.vesktop.enable;
        matugenTemplateEquibop = config.programs.vesktop.enable;
        matugenTemplateGhostty = config.programs.ghostty.enable;
        matugenTemplateKitty = config.programs.kitty.enable;
        matugenTemplateFoot = config.programs.foot.enable;
        matugenTemplateAlacritty = config.programs.alacritty.enable;
        matugenTemplateNeovim = false;
        matugenTemplateWezterm = config.programs.wezterm.enable;
        matugenTemplateDgop = true;
        matugenTemplateKcolorscheme = true;
        matugenTemplateVscode = config.programs.vscode.enable;
        matugenTemplateEmacs = config.programs.emacs.enable;
      };
    };

    profiles.packages.terminal.kitty.extraConfig = [
      "include dank-tabs.conf"
      "include dank-theme.conf"
    ];

    programs.ghostty.settings = {
      theme = "dankcolors";
      app-notifications = "no-clipboard-copy,no-config-reload";
    };

    wayland.windowManager.hyprland.settings = {
      source = [
        "dms/colors.conf"
        "dms/layout.conf"
        "dms/windowrules.conf"
      ];
    };
  };

}

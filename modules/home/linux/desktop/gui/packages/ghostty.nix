{ config, lib, ... }:
let
  isdesktop = config.profiles.desktop.enable;
in
{
  programs.ghostty = lib.optionalAttrs isdesktop {
    enable = false;
    settings = {
      font-size = 16;
      font-family = "${config.profiles.fonts.default}";

      window-theme = "auto";

      background-opacity = 0.78;
      background-blur = true;
      keybind = [
      ];
    };
    clearDefaultKeybinds = true;
    # enableBashIntegration = true;
    # enableZshIntegration = true;
    # enableFishIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    systemd.enable = true;
  };
}

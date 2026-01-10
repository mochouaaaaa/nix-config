{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.packages.terminal.wezterm;
in
{

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {
    programs =
      let
        warpper_shell = ''
          if [[ -n "$WEZTERM_EXECUTABLE" ]]; then
              alias ssh="wezterm ssh"
          fi
        '';
      in
      {
        wezterm = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };
        zsh.initContent = lib.mkOrder 2410 warpper_shell;
        bash.initExtra = lib.mkOrder 2410 warpper_shell;
      };
    xdg.configFile = config.profiles.dotfileLink "wezterm";
  };
}

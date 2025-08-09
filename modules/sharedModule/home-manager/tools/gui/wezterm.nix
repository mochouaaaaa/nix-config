{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.wezterm;
in
{
  options.modules'.packages.wezterm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable wezterm.";
    };
  };

  config = lib.mkIf cfg.enable {
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
        tmux = {
          extraConfig = lib.mkAfter ''
            # Wezterm termianl Use 
            set -g update-environment "IS_WEZTERM"
          '';
        };
        zsh.initContent = lib.mkOrder 2410 warpper_shell;
        bash.initExtra = lib.mkOrder 2410 warpper_shell;
      };
    xdg.configFile = config.modules'.dotfileLink "wezterm";
  };
}

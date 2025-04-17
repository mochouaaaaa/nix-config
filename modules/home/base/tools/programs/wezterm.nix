{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.packages.wezterm;
in
{
  options.modules.packages.wezterm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable wezterm.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      wezterm = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      zsh.initExtra = lib.mkOrder 1850 ''
        if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
            alias ssh="wezterm ssh"
        fi
      '';
    };
    xdg.configFile = config.dotfileLink "wezterm";
  };
}

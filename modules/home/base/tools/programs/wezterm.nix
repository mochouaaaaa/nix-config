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
      zsh.initExtra = ''
        alias ssh="wezterm ssh"
      '';
    };
    xdg.configFile = {
      "wezterm" = {
        force = true;
        recursive = true;
        executable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/wezterm";
      };
    };
  };
}

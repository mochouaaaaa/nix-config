{
  lib,
  pkgs,
  config,
  pkgs-unstable,
  ...
}:
let
  cfg = config.modules.packages.kitty;
in
{
  options.modules.packages.kitty = {
    extraConfig = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "include init.conf"
        "shell ${pkgs.zsh}/bin/zsh --login --interactive"
      ];
      description = "Extra configuration lines for kitty.conf.";
    };
  };

  config = {
    programs = {
      zsh.initExtra = ''
        # Completion for kitty
        kitty +complete setup zsh | source /dev/stdin
        alias ssh="kitty +kitten ssh"
      '';
      kitty = {
        enable = true;
        package = pkgs-unstable.kitty;
        font = {
          name = "Monaco Nerd Font Mono";
          size = 16;
        };
        themeFile = "Catppuccin-Mocha";
        extraConfig = lib.concatStringsSep "\n" (cfg.extraConfig);
        shellIntegration = {
          enableZshIntegration = true;
          enableBashIntegration = true;
        };
      };
    };

    xdg.configFile = {
      "kitty" = {
        force = true;
        recursive = true;
        executable = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/kitty";
      };
    };
  };
}

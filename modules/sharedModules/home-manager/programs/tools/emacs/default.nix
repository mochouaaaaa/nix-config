{ config, lib, ... }:
let
  cfg = config.profiles.packages.emacs;
in
{
  options.profiles.packages.emacs = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable emacs package.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.emacs = {
      enable = true;
      client.enable = true;
    };
    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.evil
        epkgs.evil-collection
      ];
      extraConfig = ''
        (require 'evil)
        (evil-mode 1)

        (setq evil-want-integration t)
        (setq evil-want-keybinding nil)
      '';
    };
  };
}

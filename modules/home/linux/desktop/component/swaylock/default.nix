{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.component.swaylock;
in
{
  options.modules'.desktop.component.swaylock = {
    enable = lib.mkEnableOption "swaylock" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "Lock" ''

        swaylock \
            --screenshots \
            --clock \
            --indicator \
            --indicator-radius 100 \
            --indicator-thickness 7 \
            --effect-blur 7x5 \
            --effect-vignette 0.5:0.5 \
            --ring-color bb00cc \
            --key-hl-color 880033 \
            --line-color 00000000 \
            --inside-color 00000088 \
            --separator-color 00000000 \
            --fade-in 0.2 # --grace 2
      '')
    ];
  };
}

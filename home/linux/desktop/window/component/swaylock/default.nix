{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };

  home.file = {
    ".config/swaylock/lock.sh" = {
      text = ''
        #!/usr/bin/env bash

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
            --fade-in 0.2 # --grace 2 \
      '';
      executable = true;
    };
  };

  services.xremap = {
    config = {
      keymap = [
        {
          name = "swaylock";
          exact_match = true;
          remap = {
            "SUPER-C-q" = {
              launch = ["bash" "-c" "$HOME/.config/swaylock/lock.sh"];
            };
          };
        }
      ];
    };
  };
}

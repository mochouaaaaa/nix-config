{
  pkgs,
  lib,
  isNixos,
  ...
}:
let
  image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/JaKooLit/NixOS-Hyprland/main/assets/fastfetch/nixos.png";
    hash = "sha256-MG4t8KvfrBowZzLpkkl2EYWX5KqS6wxHSNrTUnMQaaM=";
  };
in
{
  programs.fastfetch = {
    enable = true;
    # Pass the attribute set directly to the settings option, which is the
    # idiomatic way to configure this Home Manager module.
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        type = "kitty-icat";
        height = 18;
        width = 36;
        padding.top = 1;
      } // lib.optionalAttrs isNixos { source = "${image}"; };
      display.separator = " 󰑃  ";
      modules = [
        "break"
        { type = "os"; key = " DISTRO"; keyColor = "yellow"; }
        { type = "kernel"; key = "│ ├"; keyColor = "yellow"; }
        { type = "packages"; key = "│ ├󰏖"; keyColor = "yellow"; }
        { type = "shell"; key = "│ └"; keyColor = "yellow"; }
        { type = "wm"; key = " DE/WM"; keyColor = "blue"; }
        { type = "wmtheme"; key = "│ ├󰉼"; keyColor = "blue"; }
        { type = "icons"; key = "│ ├󰀻"; keyColor = "blue"; }
        { type = "cursor"; key = "│ ├"; keyColor = "blue"; }
        { type = "terminalfont"; key = "│ ├"; keyColor = "blue"; }
        { type = "terminal"; key = "│ └"; keyColor = "blue"; }
        { type = "host"; key = "󰌢 SYSTEM"; keyColor = "green"; }
        { type = "cpu"; key = "│ ├󰻠"; keyColor = "green"; }
        { type = "gpu"; key = "│ ├󰻑"; format = "{2}"; keyColor = "green"; }
        { type = "display"; key = "│ ├󰍹"; keyColor = "green"; compactType = "original-with-refresh-rate"; }
        { type = "memory"; key = "│ ├󰾆"; keyColor = "green"; }
        { type = "swap"; key = "│ ├󰓡"; keyColor = "green"; }
        { type = "uptime"; key = "│ ├󰅐"; keyColor = "green"; }
        { type = "display"; key = "│ └󰍹"; keyColor = "green"; }
        { type = "sound"; key = " AUDIO"; format = "{2}"; keyColor = "magenta"; }
        { type = "player"; key = "│ ├󰥠"; keyColor = "magenta"; }
        { type = "media"; key = "│ └󰝚"; keyColor = "magenta"; }
        {
          type = "custom";
          format = "[90m  [31m  [32m  [33m  [34m  [35m  [36m  [37m  [38m  [39m  [39m    [38m  [37m  [36m  [35m  [34m  [33m  [32m  [31m  [90m ";
        }
        "break"
      ];
    };
  };
}


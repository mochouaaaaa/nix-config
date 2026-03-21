{
  pkgs,
  lib,
  isNixos,
  myvars,
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
        type = "kitty";
        preserveAspectRatio = true;
      }
      // lib.optionalAttrs isNixos { source = "${image}"; };
      display = {
        separator = " · ";
        color = {
          separator = "#313244";
        };
        hideCursor = true;
      };
      modules = [
        {
          type = "version";
          key = " ";
          format = "• Fastfetch {version}";
          outputColor = "bold_#fab387";
        }
        {
          type = "custom";
          key = "• ${myvars.userfullname} Flake";
          keyColor = "bold_#fab387";
          format = "https://github.com/${myvars.userfullname}/nix-config";
          outputColor = "bold_#fab387";
        }
        "break"
        {
          key = "• Host     ";
          keyColor = "#f5c2e7";
          type = "board";
        }
        {
          key = "  • Memory ";
          keyColor = "#eba0ac";
          type = "memory";
        }
        {
          key = "  • CPU    ";
          keyColor = "#cba6f7";
          type = "cpu";
        }
        {
          key = "  • GPU    ";
          keyColor = "#94e2d5";
          type = "gpu";
        }
        {
          key = "• OS       ";
          keyColor = "#89dceb";
          type = "os";
        }
        {
          key = "  • Kernel ";
          keyColor = "#a6adc8";
          type = "kernel";
        }
        {
          key = "  • Uptime ";
          keyColor = "#b4befe";
          type = "uptime";
        }
        {
          key = "• Packages ";
          keyColor = "#f9e2af";
          type = "packages";
        }
        {
          key = "• Btrfs    ";
          keyColor = "#cba6f7";
          type = "btrfs";
        }
        {
          key = "• Terminal ";
          keyColor = "#f2cdcd";
          type = "terminal";
        }
        {
          key = "  • Font   ";
          keyColor = "#6c7086";
          type = "terminalfont";
        }
        {
          key = "• Desktop  ";
          keyColor = "#74c7ec";
          type = "wm";
        }
        {
          key = "  • Font   ";
          keyColor = "#6c7086";
          type = "font";
        }
        "break"
        {
          type = "colors";
          symbol = "diamond";
        }
        {
          type = "title";
          key = "The Star-Chase Nameless";
          keyColor = "bold_#fab387";
          format = "{full-user-name} ({user-name}@{host-name})";
          outputColor = "bold_#fab387";
        }
      ];
    };
  };
}

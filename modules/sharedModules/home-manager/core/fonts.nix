{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.profiles.fonts;
in
{

  options.profiles.fonts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable font configuration.";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "Monaco Nerd Font";
    };
    serif = lib.mkOption {
      type = lib.types.str;
      default = "Source Han Serif";
    };
    sansSerif = lib.mkOption {
      type = lib.types.str;
      default = "Source Han Sans";
    };
    monospace = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono CN";
    };
    emoji = lib.mkOption {
      type = lib.types.str;
      default = [
        "Apple Color Emoji"
        "Symbols Nerd Font"
        "Noto Color Emoji"
      ];
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.fonts.monaco
        maple-mono.opentype
        inter

        # Icon fonts
        fira-code
        nerd-fonts.symbols-only

        # General purpose fonts from former os/fonts.nix
        noto-fonts
        noto-fonts-cjk-sans
        source-sans
        source-serif
        source-han-sans
        source-han-serif
      ];

      fonts.fontconfig = lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux) {
        defaultFonts = {
          serif = [
            cfg.default
            cfg.serif
          ];
          sansSerif = [ cfg.sansSerif ];
          monospace = [ cfg.monospace ];
          emoji = cfg.emoji;
        };
      };
    })

    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = [
        inputs.apple-emoji-font.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux
      ];
      fonts.fontconfig = {
        enable = true;
        antialiasing = true;
      };
      # xdg.dataFile = {
      #   "fonts".source = "/run/current-system/sw/share/X11/fonts";
      # };
    })
  ];
}

{
  lib,
  pkgs,
  config,
  ...
}:
let

  cfg = config.profiles.fonts;

  # Custom derivation for Monaco Nerd Font, as it's not in nixpkgs.
  MonacoNerdFont = pkgs.fetchzip {
    url = "https://github.com/thep0y/monaco-nerd-font/releases/download/v0.2.1/MonacoNerdFont.zip";
    sha256 = "sha256-Sal3Oa1H5Ng56VxTLToSjfSwsFFm0EtU3UksPa4P4+c=";
    stripRoot = false;
  };

  MonacoNerdFontMono = pkgs.fetchzip {
    url = "https://github.com/thep0y/monaco-nerd-font/releases/download/v0.2.1/MonacoNerdFontMono.zip";
    sha256 = "sha256-gu1n+GRgiCWBka01B+jrvU2a4T3u9y1/RlspOcWMErE=";
    stripRoot = false;
  };

  monaco-nerd-font = pkgs.stdenv.mkDerivation {
    name = "monaco-nerd-font";
    srcs = [
      MonacoNerdFont
      MonacoNerdFontMono
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -r ${MonacoNerdFont}/* $out/share/fonts/opentype
      cp -r ${MonacoNerdFontMono}/* $out/share/fonts/opentype
    '';
  };
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
      default = "Noto Color Emoji";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        # monaco
        monaco-nerd-font
        maple-mono.opentype
        maple-mono.CN
        inter

        # Icon fonts
        fira-code
        font-awesome
        material-design-icons
        nerd-fonts.symbols-only

        # General purpose fonts from former os/fonts.nix
        noto-fonts
        noto-fonts-cjk-sans
        source-sans
        source-serif
        source-han-sans
        source-han-serif
        mononoki
        dejavu_fonts
      ];

      fonts.fontconfig = lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux) {
        defaultFonts = {
          serif = [
            cfg.default
            cfg.serif
          ];
          sansSerif = [ cfg.sansSerif ];
          monospace = [ cfg.monospace ];
          emoji = [ cfg.emoji ];
        };
      };
    })

    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      fonts.fontconfig = {
        enable = true;
        antialiasing = true;
      };
      xdg.dataFile = {
        "fonts".source = "/run/current-system/sw/share/X11/fonts";
      };
    })
  ];
}

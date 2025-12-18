{
  pkgs,
  lib,
  config,
  ...
}:
let
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

  makeFonts = pkgs.stdenv.mkDerivation {
    name = "make-fonts";
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
  config = lib.mkIf (!config.programs.wsl.enable) {
    # Enable fontconfig for non-NixOS Linux systems.
    fonts.fontconfig.enable = pkgs.stdenv.isLinux;

    # Consolidate all font packages into home.packages for portability.
    home.packages =
      (
        with pkgs;
        [
          # Custom fonts
          makeFonts # Custom Monaco Nerd Font
          maple-mono.NF
          inter

          # Icon fonts
          font-awesome
          material-design-icons

          # General purpose fonts from former os/fonts.nix
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          source-sans
          source-serif
          source-han-sans
          source-han-serif
          mononoki
          julia-mono
          dejavu_fonts

          # Fontconfig for Linux
        ]
        ++ lib.optionals (pkgs.stdenv.isLinux) [ fontconfig ]
      )
      # Add all Nerd Fonts (this is a large set)
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}

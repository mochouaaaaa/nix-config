{ lib, pkgs, ... }:
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

  monaco = pkgs.stdenv.mkDerivation rec {
    pname = "monaco";
    version = "0.2.1";
    src = pkgs.fetchFromGitHub {
      owner = "thep0y";
      repo = "monaco-nerd-font";
      tag = "v${version}";
      hash = "sha256-+Z55U3dPb+wyjlSrJ447PlKkW9uyFpRFXDIB+OgORXI=";
    };

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      find $src -type f -name "*.ttf" -exec cp {} $out/share/fonts/opentype/ \;
    '';
  };
in
{
  fonts.packages = with pkgs; [
    monaco
    monaco-nerd-font
    maple-mono.opentype
    maple-mono.CN
    inter

    # Icon fonts
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

}

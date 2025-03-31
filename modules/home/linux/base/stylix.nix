{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.modules.desktop.component.stylix;

  GetMonacoNerdFontMono = pkgs.fetchzip {
    url = "https://github.com/thep0y/monaco-nerd-font/releases/download/v0.2.1/MonacoNerdFontMono.zip";
    sha256 = "sha256-gu1n+GRgiCWBka01B+jrvU2a4T3u9y1/RlspOcWMErE=";
    stripRoot = false;
  };
  MonacoNerdFontMono = pkgs.stdenv.mkDerivation {
    name = "monaco-nerd-font-mono";
    src = GetMonacoNerdFontMono;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -r $src/* $out/share/fonts/opentype
    '';
  };
in {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  options.modules.desktop.component.stylix = {
    enable = lib.mkEnableOption "Stylix Desktop Environment";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;

      targets = {
        bat.enable = false;
        btop.enable = false;
        lazygit.enable = false;
        neovim.enable = false;
        fcitx5.enable = false;
        kitty.enable = false;
      };

      fonts = {
        monospace = {
          package = MonacoNerdFontMono;
          name = "Monaco Nerd Font";
        };
        sansSerif = {
          package = MonacoNerdFontMono;
          name = "Monaco Nerd Font";
        };
        serif = {
          package = MonacoNerdFontMono;
          name = "Monaco Nerd Font";
        };
      };

      opacity = {
        applications = 0.3;
        terminal = 0.3;
      };

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      # image = "${config.home.homeDirectory}/Pictures/wallpapers/zhizi.jpg";
      # image = pkgs.fetchurl {
      #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
      # };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      iconTheme = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
    };
  };
}

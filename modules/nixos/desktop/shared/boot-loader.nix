{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    boot.loader = {
      grub = {
        enable = false;
        fontSize = 16;
        font = "${pkgs.maple-mono.NF}/share/fonts/truetype/MapleMono-NF-Regular.ttf";
      };

      limine = {
        enable = true;
        maxGenerations = 10;
        resolution = "1920x1080";
        style.interface.resolution = "1920x1080";
        extraConfig = ''
          timeout: 15
          graphics: yes

          term_palette: 1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
          term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
          term_background: 1e1e2e
          term_foreground: cdd6f4
          term_background_bright: 585b70
          term_foreground_bright: cdd6f4
        '';
      };

    };

  };

}

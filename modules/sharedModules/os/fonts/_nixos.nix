{
  pkgs,
  inputs,
  ...
}:
{
  config = {

    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = false;
      packages = [
        inputs.apple-emoji-font.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji-linux
      ];
      fontconfig = {
        useEmbeddedBitmaps = true;
        defaultFonts = {
          serif = [
            "Monaco Nerd Font"
            "Source Han Serif"
          ];
          sansSerif = [ "Source Han Sans" ];
          monospace = [ "Maple Mono CN" ];
          emoji = [
            "Apple Color Emoji"
            "Symbols Nerd Font"
            "Noto Color Emoji"
          ];
        };
      };
    };
  };
}

{
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {

    fonts = {
      fontDir.enable = true;
      packages = [ pkgs.corefonts ];
      fontconfig = {
        useEmbeddedBitmaps = true;
        defaultFonts = {
          serif = [
            "Monaco Nerd Font"
            "Source Han Serif"
          ];
          sansSerif = [ "Source Han Sans" ];
          monospace = [ "Maple Mono CN" ];
        };
      };
    };

    home-manager.sharedModules = [
      {
        config = {
          xdg.dataFile = {
            "fonts".source = "/run/current-system/sw/share/X11/fonts";
          };
        };

        options.profiles.fonts = {
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
      }
    ];

  };
}

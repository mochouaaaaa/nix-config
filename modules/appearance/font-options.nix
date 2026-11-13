{
  flake.modules.homeManager."appearance.font-options" =
    { lib, ... }:
    {
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
          type = lib.types.listOf lib.types.str;
          default = [
            "Apple Color Emoji"
            "Symbols Nerd Font"
            "Noto Color Emoji"
          ];
        };
      };
    };
}

{
  flake.modules.homeManager."programs.mpv.translations" =
    { pkgs, ... }:
    let
      translations = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Samillion/ModernZ/refs/heads/main/extras/locale/modernz-locale.json";
        hash = "sha256-XTBkIn131MlSpEqBT/0HNuPLPX6M8Hsi3LjNR1BYjLI=";
      };
    in
    {

      xdg.configFile."mpv/script-opts/modernz-locale.json" = {
        source = translations;
      };

    };
}

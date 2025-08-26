{
  pkgs,
  lib,
  config,
  ...
}:
let
  translations = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Samillion/ModernZ/refs/heads/main/extras/locale/modernz-locale.json";
    hash = "sha256-nwJrZWyPbtz1ZC+899+Dy638BTotBI196/zoI1xvaLA=";
  };
in
{
  config = lib.mkIf config.programs.mpv.enable {
    xdg.configFile."mpv/script-opts/modernz-locale.json" = {
      source = translations;
    };
  };
}

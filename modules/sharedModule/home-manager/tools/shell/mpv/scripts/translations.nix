{
  pkgs,
  lib,
  config,
  ...
}:
let
  translations = pkgs.fetchurl {
    url = "https://github.com/Samillion/ModernZ/blob/main/extras/locale/modernz-locale.json";
    hash = "sha256-SKEqSUCaSqT74K8EMbBhNr/RyZRx7xdTM9C8fqIYOas=";
  };
in
{
  config = lib.mkIf config.programs.mpv.enable {
    xdg.configFile."mpv/script-opts/modernz-locale.json" = {
      source = translations;
    };
  };
}

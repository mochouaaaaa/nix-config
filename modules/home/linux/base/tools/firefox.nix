{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.firefox;

  themes = pkgs.stdenv.mkDerivation {
    name = "firefox-themes";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-firefox-theme";
      tag = "2025-02-12";
      hash = "sha256-aoUO+W2CMZ/d0TRoZv/4CPM2yrDGaVQ/1Q9BA0aHjOk=";
    };

    installPhase = ''
      mkdir -p $out/share/mozilla/firefox/firefox-themes

      cp -rf ./src/Monterey $out/share/mozilla/firefox/firefox-themes/
      cp -rf ./src/common/* $out/share/mozilla/firefox/firefox-themes/Monterey/


      cp -rf ./src/customChrome.css $out/share/mozilla/firefox/firefox-themes/customChrome.css
      cp -rf ./src/userChrome-Monterey.css $out/share/mozilla/firefox/firefox-themes/userChrome.css
      cp -rf ./src/userContent-Monterey.css $out/share/mozilla/firefox/firefox-themes/userContent.css
      cp -rf ./src/userChrome-Monterey-alt.css $out/share/mozilla/firefox/firefox-themes/userChrome.css
      cp -rf ./src/WhiteSur/parts/headerbar-urlbar.css $out/share/mozilla/firefox/firefox-themes/Monterey/parts/headerbar-urlbar-alt.css
    '';
  };

in
{
  config = lib.mkIf cfg.enable {

    home.file = {
      ".mozilla/firefox/${self.myvars.username}/chrome".source =
        "${themes}/share/mozilla/firefox/firefox-themes";
    };
  };
}

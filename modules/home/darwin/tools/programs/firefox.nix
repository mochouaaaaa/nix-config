{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  cfg = config.modules.packages.firefox;

  themes = pkgs.stdenv.mkDerivation {
    name = "firefox-themes";
    src = pkgs.fetchFromGitHub {
      owner = "AdamXweb";
      repo = "WhiteSurFirefoxThemeMacOS";
      tag = "v1.6.2";
      # hash = "sha256-aoUO+W2CMZ/d0TRoZv/4CPM2yrDGaVQ/1Q9BA0aHjOk=";
    };

    installPhase = ''
      mkdir -p $out/share/mozilla/firefox/firefox-themes

      cp -rf chrome $out/share/mozilla/firefox/firefox-themes
      cp -rf configuration $out/share/mozilla/firefox/firefox-themes
    '';
  };

in

{
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      profiles = {
        "${self.myvars.username}" = {
          isDefault = true;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };
      };
    };

  };
}

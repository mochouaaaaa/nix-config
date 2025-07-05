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
      hash = "sha256-fmw4fwgF16q5V8fwZl8S7/+X9IwkGLeWRxwCrPpVp80=";
    };

    installPhase = ''
      mkdir -p $out/share/mozilla/firefox/firefox-themes

      cp -rf chrome $out/share/mozilla/firefox/firefox-themes
    '';
  };

in

{
  config = lib.mkIf cfg.enable {

    home.file = {
      "Library/Application Support/Firefox/Profiles/${self.myvars.username}/chrome".source =
        "${themes}/share/mozilla/firefox/firefox-themes/chrome";
    };

    programs.firefox = {
      # package = pkgs.firefox-unwrapped;
      profiles = {
        "${self.myvars.username}" = {
          isDefault = true;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.drawInTitlebar" = true;
            "browser.uidensity" = 0;
          };
        };
      };
    };

  };
}

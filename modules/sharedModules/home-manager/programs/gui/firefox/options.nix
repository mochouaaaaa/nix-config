{ lib, config, ... }:
{

  options.profiles.packages.firefox = with lib; {
    enable = mkOption {
      type = types.bool;
      default = config.profiles.desktop.enable;
      description = "Whether to enable the firefox package.";
    };
    plugins = with lib; {
      bewlybewly = mkEnableOption "BewlyBewly";
      bitwarden = mkEnableOption "Bitwarden";
      enhanced-github = mkEnableOption "Enhanced GitHub";
      fehelper = mkEnableOption "FeHelper";
      imagus = mkEnableOption "Imagus";
      immersive-translate = mkEnableOption "Immersive Translate";
      nope-cha = mkEnableOption "NopeCHA";
      tampermonkey = mkEnableOption "Tampermonkey";
      ublock-origin = mkEnableOption "uBlock Origin";
      vimium = mkEnableOption "Vimium";
      xbrowsersync = mkEnableOption "xBrowserSync";
      duckduckgo-privacy-essentials = mkEnableOption "DuckDuckGo Privacy Essentials";
    };
  };

  config = {
    profiles.packages.firefox.plugins = {
      bewlybewly = true;
      bitwarden = true;
      enhanced-github = true;
      fehelper = true;
      imagus = true;
      immersive-translate = true;
      nope-cha = false;
      tampermonkey = true;
      ublock-origin = true;
      vimium = true;
      xbrowsersync = false;
      duckduckgo-privacy-essentials = true;
    };
  };

}

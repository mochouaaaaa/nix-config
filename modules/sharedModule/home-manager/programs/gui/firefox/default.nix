{ lib, config, ... }:
{
  imports = lib.importModule' ./.;

  options.modules' = {
    packages.firefox = with lib; {
      enable = mkOption {
        type = types.bool;
        default = config.programs.desktop.enable;
        description = "Whether to enable the firefox package.";
      };
    };
  };

  config = {
    modules'.packages.firefox.plugins = {
      bewlybewly = true;
      bitwarden = true;
      enhanced-github = true;
      fehelper = true;
      imagus = true;
      immersive-translate = true;
      nope-cha = true;
      tampermonkey = true;
      ublock-origin = true;
      vimium = true;
      xbrowsersync = true;
    };
  };

}

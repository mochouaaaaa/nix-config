{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.packages.firefox;
in
{
  options = {
    modules.packages.firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable the firefox package.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        package = pkgs.firefox-unwrapped;
        enable = true;
        languagePacks = [ "en" ];
        policies = {
          ExtensionSettings =
            with builtins;
            let
              extension = shortId: uuid: {
                name = uuid;
                value = {
                  install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
                  installation_mode = "normal_installed";
                };
              };
            in
            listToAttrs [
              (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
              (extension "immersive-translate" "{5efceaa7-f3a2-4e59-a54b-85319448e305}")
              (extension "tampermonkey" "firefox@tampermonkey.net")
              (extension "vimium" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
              (extension "GitZip" "gitzip-firefox-addons@gitzip.org")
              (extension "ublock-origin" "uBlock0@raymondhill.net")
              (extension "imagus" "{00000f2a-7cde-4f20-83ed-434fcb420d71}")
              (extension "BewlyBewly" "addon@bewlybewly.com")
            ];
        };
      };
    };
  };
}

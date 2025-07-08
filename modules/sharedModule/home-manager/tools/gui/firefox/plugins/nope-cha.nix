{
  pkgs,
  lib,
  myvars,
  ...
}:
{
  programs = {
    firefox = {
      profiles = {
        "${myvars.username}" = {
          extensions = {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              (pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon rec {
                pname = "NopeCHA: CAPTCHA Solver";
                version = "0.4.13";
                addonId = "{2f67aecb-5dac-4f76-9378-0ac4f2bedc9c}";
                url = "https://addons.mozilla.org/firefox/downloads/file/4393222/noptcha-${version}.xpi";
                sha256 = "sha256-HvH8p8dcxIcUaASav/HM7YblD3dHJxCWRbXWDywBP6M=";
                meta = with lib; {
                  homepage = "https://www.fehelper.com";
                  description = "AI Solver for reCAPTCHA, FunCAPTCHA, and all CAPTCHA.";
                  license = licenses.mit;
                  mozpermissions = [
                    "scripting"
                    "storage"
                    "webRequest"
                    "webRequestBlocking"
                    "<all_urls>"
                  ];
                  platforms = platforms.all;
                };
              })
            ];

          };
        };
      };
    };
  };
}

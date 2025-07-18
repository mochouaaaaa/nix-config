{
  pkgs,
  username,
  ...
}:
{
  programs = {
    firefox = {
      profiles = {
        "${username}" = {
          extensions = {
            settings = {
              "uBlock0@raymondhill.net".settings = {
                force = true;
                selectedFilterLists = [
                  "ublock-filters"
                  "ublock-badware"
                  "ublock-privacy"
                  "ublock-quick-fixes"
                  "ublock-unbreak"
                  "easylist"
                  "easyprivacy"
                  "urlhaus-1"
                  "fanboy-cookiemonster"
                  "ublock-cookies-easylist"
                  "adguard-cookies"
                  "ublock-cookies-adguard"
                  "fanboy-social"
                  "adguard-social"
                ];
              };
            };
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
            ];
          };
        };
      };
    };
  };
}

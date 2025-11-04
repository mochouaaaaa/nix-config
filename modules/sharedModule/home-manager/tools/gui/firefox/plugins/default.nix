{
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = lib.importModule' ./.;

  programs = rec {
    firefox = {
      profiles = {
        "${username}" = {
          extensions = {
            force = true;
            # exactPermissions = true;
            # exhaustivePermissions = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              xbrowsersync
            ];
          };
        };
      };
    };

  };
}

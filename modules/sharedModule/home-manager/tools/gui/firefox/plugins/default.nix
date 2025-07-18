{ lib, username, ... }:
{
  imports = lib.importModule' ./.;

  programs = {
    firefox = {
      profiles = {
        "${username}" = {
          extensions = {
            force = true;
          };
        };
      };
    };
  };
}

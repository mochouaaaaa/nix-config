{ lib, myvars, ... }:
{
  imports = lib.importModule' ./.;

  programs = {
    firefox = {
      profiles = {
        "${myvars.username}" = {
          extensions = {
            force = true;
          };
        };
      };
    };
  };
}

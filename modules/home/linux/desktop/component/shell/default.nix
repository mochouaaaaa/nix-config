{ lib, ... }:
{
  imports = lib.importModule' ./.;

  config = {

    modules'.themes.auto = {
      enable = false;
    };

  };
}

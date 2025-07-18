{
  lib,
  ...
}:
{
  imports = lib.importModule' ./.;

  config = {
    keymaps.Super = lib.mkDefault "cmd";
  };
}

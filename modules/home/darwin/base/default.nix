{
  lib,
  username,
  ...
}:
{
  imports = lib.importModule' ./.;

  config = {
    keymaps.Super = lib.mkDefault "cmd";
  };
}

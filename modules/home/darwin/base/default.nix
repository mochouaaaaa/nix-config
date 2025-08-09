{
  lib,
  username,
  ...
}:
{
  imports = lib.importModule' ./.;

  config.modules' = {
    keymaps.Super = lib.mkDefault "cmd";
  };
}

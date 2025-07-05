{
  self,
  lib,
  ...
}:
{
  imports = self.importModule' ./.;

  config = {
    keymaps.Super = lib.mkDefault "cmd";
  };
}

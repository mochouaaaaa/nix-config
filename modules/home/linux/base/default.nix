{
  self,
  lib,
  ...
}:
{
  imports = self.importModule'  ./. ++ [ ../desktop ];

  config = {
    keymaps.Super = lib.mkDefault "cmd";
  };
}

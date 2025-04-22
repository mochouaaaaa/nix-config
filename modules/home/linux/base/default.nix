{
  self,
  lib,
  ...
}:
{
  imports = self.mylib.scanPaths ./. ++ [ ../desktop ];

  config = {
    keymaps.Super = lib.mkDefault "cmd";
  };
}

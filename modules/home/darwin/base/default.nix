{
  self,
  lib,
  ...
}:
{
  imports = self.mylib.scanPaths ./.;

  config = {
    keymaps.Super = lib.mkDefault "cmd";

    home.homeDirectory = "/Users/${self.myvars.username}";
  };
}

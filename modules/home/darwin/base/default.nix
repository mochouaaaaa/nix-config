{
  self,
  lib,
  ...
}:
{
  imports = self.importModule'  ./.;

  config = {
    keymaps.Super = lib.mkDefault "cmd";

    home.homeDirectory = "/Users/${self.myvars.username}";
  };
}

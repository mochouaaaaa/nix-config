{
  self,
  ...
}:
{
  home.homeDirectory = "/Users/${self.myvars.username}";
  imports = (self.mylib.scanPaths ./.);
}

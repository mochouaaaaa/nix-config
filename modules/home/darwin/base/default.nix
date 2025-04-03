{
  mylib,
  myvars,
  ...
}:
{
  home.homeDirectory = "/Users/${myvars.username}";
  imports = (mylib.scanPaths ./.);
}

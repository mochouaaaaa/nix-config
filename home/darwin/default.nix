{
  mylib,
  myvars,
  ...
}: {
  home.homeDirectory = "/Users/${myvars.username}";
  imports = (mylib.scanPaths ./.) ++ [../base/home.nix];
}

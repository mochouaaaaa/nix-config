{mylib, ...}: {
  imports = mylib.scanPaths ./. ++ [../desktop];
}

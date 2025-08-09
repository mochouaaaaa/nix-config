{
  lib,
  ...
}:
{
  imports = lib.importModule' ./. ++ [
    ../../component
  ];
}

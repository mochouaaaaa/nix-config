{
  lib,
  inputs,
  ...
}:
{
  imports = lib.importModule' ./. ++ [ inputs.vicinae.homeManagerModules.default ];
}

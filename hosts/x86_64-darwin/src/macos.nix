{
  lib,
  self,
  inputs,
  system,
  mylib,
  myvars,
  genSpecialArgs,
  ...
} @ args: let
  modules = {
    darwin-modules = [
      ../macos
      self.darwinModules.base
    ];
    home-modules = [
      self.homeModules.darwin.base
    ];
  };

  systemArgs = modules // args;
in {
  darwinConfigurations = {
    macos = mylib.macosSystem systemArgs;
  };
}

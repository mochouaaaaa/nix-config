{
  lib,
  self,
  inputs,
  system,
  genSpecialArgs,
  ...
}@args:
let
  modules = {
    darwin-modules = [
      ../macos
      self.darwinModules.base
    ];
    home-modules = [
      self.homeModules.base.home
      self.homeModules.base.core
      self.homeModules.base.tools

      self.homeModules.darwin.base

      {
        modules.packages.envs = {
          pyenv.enable = true;
          goenv.enable = true;
          nodenv.enable = true;
          luaenv.enable = true;
        };
      }

    ];
  };

  systemArgs = modules // args;
in
{
  darwinConfigurations = {
    macos = self.mylib.macosSystem systemArgs;
  };
}

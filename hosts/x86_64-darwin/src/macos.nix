{
  lib,
  self,
  inputs,
  system,
  genSpecialArgs,
  getSystems,
  ...
}@args:
let
  modules = {
    darwin-modules = [
      ../macos

      {
        modules.packages = {
          openvpn.enable = true;
          tunnelblick.enable = true;
        };
      }

    ];
    home-modules = [
      # self.homeModules.base.home
      # self.homeModules.base.core
      # self.homeModules.base.tools

      self.homeModules.darwin.modules
      # self.homeModules.darwin.base
      # self.homeModules.darwin.tools

      {
        modules.packages = {
          wezterm.enable = true;
          ollama.enable = false;
          firefox.enable = false;
          bitwarden.enable = false;
          envs = {
            pyenv.enable = true;
            goenv.enable = true;
            nodenv.enable = true;
            luaenv.enable = true;
          };
        };
      }
    ];
  };

  systemArgs = modules // args;
in
{
  darwinConfigurations = {
    macos = getSystems.macosSystem systemArgs;
  };
}

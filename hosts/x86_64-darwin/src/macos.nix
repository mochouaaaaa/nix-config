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
          aerospace.enable = false;
          database-suite.enable = true;
          rustdesk.enable = true;
        };
      }

    ];
    home-modules = [

      self.homeModules.darwin.modules

      {
        modules.packages = {
          wezterm.enable = true;
          ollama.enable = false;
          firefox.enable = true;
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

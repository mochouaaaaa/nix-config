{ self, inputs, ... }:
let
  homeModules = [
    self.homeModules.darwin.modules
    {
      modules'.packages = {
        terminal = {
          wezterm.enable = true;
        };

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
in
{

  flake-parts = {
    darwinConfigurations = {
      "mochou@darwin" = {
        system = "x86_64-darwin";
        stateVersion = 5;

        modules = [

          self.darwinModules.base
          {
            modules'.packages = {
              openvpn.enable = true;
              tunnelblick.enable = true;
              aerospace.enable = false;
              database-suite.enable = true;
              rustdesk.enable = true;
            };
          }

        ];
        homeModules = homeModules;
      };
    };

    homeConfigurations = {
      "mochou@darwin" = {
        system = "x86_64-darwin";
        stateVersion = "24.11";
        modules = homeModules;
      };
    };
  };
}

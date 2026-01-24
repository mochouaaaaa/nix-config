{ self, ... }:
let
  homeModules = [
    self.homeModules.darwin

    {
      profiles = {
        languages = {
          envs = {
            python.enable = true;
            goenv.enable = true;
            node.enable = true;
            rust.enable = true;
          };
        };
        packages = {
          terminal = {
            kitty.enable = true;
            wezterm.enable = false;
          };

          ollama.enable = false;
          firefox.enable = true;
          bitwarden.enable = false;
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
            profiles.packages = {
              openvpn.enable = false;
              tunnelblick.enable = true;
              aerospace.enable = false;
              database-suite.enable = false;
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

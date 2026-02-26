{ self, inputs, ... }:
let
  homeModules = [
    self.homeModules.darwin

    {
      profiles = {
        secrets.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTnhFwOTyrb2gMvEyV6I83L7Xrek8bnzcg2FW6UahY";
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

          ollama.enable = true;
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
        stateVersion = 6;

        modules = [
          (inputs.import-tree ./_darwin)

          self.darwinModules.default
          {
            profiles = {
              packages = {
                openvpn.enable = false;
                tunnelblick.enable = true;
                aerospace.enable = false;

                rustdesk.enable = true;
              };
              services = {
                database-suite.enable = false;
              };
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

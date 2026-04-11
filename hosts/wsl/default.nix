{
  self,
  inputs,
  ...
}:
let
  homeModules = [
    self.homeModules.wsl

    {
      profiles = {
        secrets.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECNEOhSUgaHrFy8WYaHcFTTyeBDaS2bNXj/mE7RCkGo";
        wsl.enable = true;
        languages = {
          envs = {
            python.enable = true;
            goenv.enable = true;
            node.enable = true;
            rust.enable = true;
          };
        };

        packages = {
          # tencent enable default use true
        };
      };
    }
  ];

in
{

  flake-parts = {
    nixosConfigurations = {
      "mochou@wsl" = {
        system = "x86_64-linux";
        stateVersion = "25.05";
        modules = [
          inputs.nixos-wsl.nixosModules.default

          self.nixosModules.default
        ]
        ++ [
          (
            {
              config,
              lib,
              pkgs,
              ...
            }:

            {
              wsl.enable = true;
              wsl.defaultUser = "mochou";
              wsl.docker-desktop.enable = true;
              wsl.useWindowsDriver = true;
              wsl.startMenuLaunchers = true;
              wsl.usbip.enable = true;
              wsl.ssh-agent.enable = true;

              profiles.wsl.enable = true;

              environment.systemPackages = with pkgs; [
                docker
                docker-compose
              ];

              users.groups.docker.members = [
                config.wsl.defaultUser
              ];

              programs.nix-ld.enable = lib.mkForce true;
            }
          )
        ];

        homeModules = homeModules;
      };
    };

    homeConfigurations = {
      "mochou@wsl" = {
        system = "x86_64-linux";
        stateVersion = "24.11";
        modules = homeModules;
      };
    };
  };
}

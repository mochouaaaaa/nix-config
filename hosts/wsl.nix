{
  self,
  inputs,
  ...
}:
let
  homeModules = [
    self.homeModules.wsl.modules

    {
      programs.wsl.enable = true;

      modules'.packages = {
        # tencent enable default use true

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
    nixosConfigurations = {
      "mochou@wsl" = {
        system = "x86_64-linux";
        stateVersion = "25.05";
        modules = [
          inputs.nixos-wsl.nixosModules.default

          self.nixosModules.base

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

              programs.wsl.enable = true;

              environment.systemPackages = with pkgs; [

                docker
                docker-compose
              ];

              # systemd.services.docker-desktop-proxy = {
              #   description = "Docker Desktop proxy";
              #   script = ''
              #     ${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop
              #   '';
              #   wantedBy = [ "multi-user.target" ];
              #   serviceConfig = {
              #     Restart = "on-failure";
              #     RestartSec = "30s";
              #   };
              # };

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

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

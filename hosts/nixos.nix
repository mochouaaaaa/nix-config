{ self, ... }:
let
  # Define Home Manager modules list, combining the generic linux modules
  # with the host-specific home-manager settings from the dedicated file.
  homeModules = [
    self.homeModules.linux.modules
    ./nixos/home-settings.nix
  ];

in
{
  flake-parts = {
    nixosConfigurations = {
      "mochou@nixos" = {
        system = "x86_64-linux";
        stateVersion = "25.05";
        modules = [
          ./nixos/default.nix
          ./nixos/settings.nix # Import host-specific NixOS settings

          # Import generic NixOS modules
          self.nixosModules.base
          self.nixosModules.services
          self.nixosModules.virtual
          self.nixosModules.desktop
        ];

        homeModules = homeModules;
      };
    };

    homeConfigurations = {
      "mochou@nixos" = {
        system = "x86_64-linux";
        stateVersion = "24.11";
        modules = homeModules;
      };
    };
  };
}

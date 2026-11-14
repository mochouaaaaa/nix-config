{
  flake.modules.homeManager.workstation = { inputs, pkgs, ... }: {
    home.packages = [
      inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.jetbra-free
    ];
  };
  flake.modules.nixos.preservation =
    {
      inputs,
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages or [ ];
      jetbra = inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.jetbra-free;
    in
    {
      profiles.preservation.users.${username}.directories = lib.optionals (lib.elem jetbra homePackages) [
        ".config/JetBrains"
        ".cache/JetBrains"
        ".local/share/JetBrains"
        ".config/.jetbra-free"
      ];
    };
}

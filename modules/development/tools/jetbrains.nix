{
  flake.aspects."development.gui".homeManager = { inputs, pkgs, ... }: {
    home.packages = [
      inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.jetbra-free
    ];
  };

  flake.aspects.preservation.nixos =
    {
      inputs,
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages;
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

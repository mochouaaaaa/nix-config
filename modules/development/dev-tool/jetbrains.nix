{
  flake.modules.homeManager.linux = { inputs, pkgs, ... }: {
    home.packages = [
      inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.jetbra-free
    ];
  };

  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      # jetbrains
      ".config/JetBrains"
      ".cache/JetBrains"
      ".local/share/JetBrains"
      ".config/.jetbra-free"
    ];
  };

}

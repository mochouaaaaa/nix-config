{
  imports = [
    ./pyenv.nix
    ./luaenv.nix
  ];

  perSystem =
    {
      inputs',
      pkgs,
      pkgs-stable,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix flake plugins";
        packages = with pkgs; [
          bashInteractive
          just
          nixd
          nvfetcher
          home-manager
        ];
        shellHook = ''
          echo -e "\033[1;32m==> Welcome to Nix-Config ✅\033[0m"
        '';
      };
    };
}

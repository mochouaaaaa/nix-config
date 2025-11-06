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
          # bashInteractive

          home-manager
          just
          nixd
          nvfetcher
        ];
        shellHook = ''
          echo -e "\033[1;32m==> Welcome to Nix-Config ✅\033[0m"
          # just --completions zsh
        '';
      };
    };
}

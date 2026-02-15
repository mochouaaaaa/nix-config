{
  perSystem =
    {
      inputs,
      system,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix flake plugins";

        packages = with pkgs; [
          home-manager
          just
        ];

        shellHook = ''
          echo -e "\033[1;32m==> Welcome to Nix-Config ✅\033[0m"
        '';
      };
      formatter.${system} = pkgs.nixfmt-tree;
    };
}

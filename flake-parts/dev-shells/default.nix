{
  imports = [
    ./pyenv.nix
    ./luaenv.nix
  ];

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
          devenv
        ];
      };
    };
}

{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default = pkgs.mkShell {

        name = "nix flake";

        nativeBuildInputs = [ config.agenix-rekey.package ];
        env.AGENIX_REKEY_ADD_TO_GIT = true;

        packages = with pkgs; [
          age
          just
          nixfmt
          statix
          deadnix
        ];

        shellHook = ''
          echo -e "\033[1;32m==> Welcome to Nix-Config ✅\033[0m"
        '';

      };
    };
}

# nix develop

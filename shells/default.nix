{
  perSystem =
    {
      inputs,
      system,
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix flake plugins";

        nativeBuildInputs = [ config.agenix-rekey.package ];
        env.AGENIX_REKEY_ADD_TO_GIT = true;

        packages = with pkgs; [
          home-manager
          just
          age
        ];

        shellHook = ''
          echo -e "\033[1;32m==> Welcome to Nix-Config ✅\033[0m"
        '';
      };
    };
}

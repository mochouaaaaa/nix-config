{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.agenix = pkgs.mkShell {
        name = "agenix";

        inputsFrom = [ config.devShells.default ];

        packages = [
          pkgs.age
        ];

        nativeBuildInputs = [
          config.agenix-rekey.package
        ];

        env = {
          AGENIX_REKEY_ADD_TO_GIT = true;
        };
      };
    };
}

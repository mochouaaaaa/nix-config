{
  # Optional compatibility environment for software that expects a conventional
  # FHS runtime. Hosts opt in explicitly instead of inheriting it from nixos.core.
  flake.aspects."profiles.compat".nixos =
    { pkgs, ... }:
    let
      fhsArgs = pkgs.appimageTools.defaultFhsEnvArgs;
    in
    {
      environment.systemPackages = [
        (pkgs.buildFHSEnv (
          fhsArgs
          // {
            name = "fhs";
            targetPkgs =
              pkgs:
              (fhsArgs.targetPkgs pkgs)
              ++ [
                pkgs.pkg-config
                pkgs.zsh
              ];
            profile = "export FHS=1";
            runScript = "zsh";
            # extraOutputsToInstall = [ "dev" ];
          }
        ))
        pkgs.pkg-config
      ];

      programs.nix-ld = {
        enable = true;
        libraries =
          (fhsArgs.targetPkgs pkgs)
          ++ (fhsArgs.multiPkgs pkgs)
          ++ (with pkgs; [
            readline
            ncurses
            libffi
            sqlite
            tcl
            tk
            dbus
            dbus-glib
            glib
            libgpg-error
          ]);
      };
    };
}

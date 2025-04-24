{
  perSystem =
    {
      inputs',
      pkgs,
      pkgs-stable,
      lib,
      ...
    }:
    {
      devShells.pyenv = pkgs.mkShell rec {
        name = "pyenv-install";
        description = "pyenv install `Python` development shell";
        nativeBuildInputs = with pkgs; [
          autoreconfHook
          pkg-config
          stdenv.cc
        ];
        buildInputs =
          with pkgs;
          [
            bzip2
            expat
            libffi
            libxcrypt
            mpdecimal
            ncurses
            openssl
            sqlite
            readline
            xz
            zlib
            pkgs-stable.tcl
            pkgs-stable.tk
          ]
          ++ lib.optionals (pkgs.stdenv.isDarwin) [
            tcl-9_0
            tk-9_0
          ]
          ++ lib.optionals (pkgs.stdenv.isLinux) [
            bluez
            pkgs-stable.tcl-9_0
            pkgs-stable.tk-9_0
          ];
        env = {
          CPPFLAGS = lib.concatStringsSep " " (map (p: "-I${lib.getDev p}/include") buildInputs);
          LDFLAGS = lib.concatStringsSep " " (map (p: "-L${lib.getLib p}/lib") buildInputs);
        };
        shellHook = ''
          echo -e "\033[1;32m==> Welcome to Pyenv install python development  ✅\033[0m"
        '';
      };
    };
}

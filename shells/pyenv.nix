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
            bashInteractive

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
            # pkgs-stable.tcl
            # pkgs-stable.tk
            tcl
            tk
            tcl-9_0
            (tk-9_0.overrideAttrs (oldAttrs: {
              postInstall = ''
                ln -s $out/bin/wish* $out/bin/wish
                cp ../{unix,generic}/*.h $out/include
                ln -s $out/lib/libtcl9tk${tcl-9_0.release}${pkgs.stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libtk${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}
              ''
              + lib.optionalString (pkgs.stdenv.hostPlatform.isDarwin) ''
                cp ../macosx/*.h $out/include
              '';
            }))
          ]
          ++ lib.optionals (pkgs.stdenv.isDarwin) [
            clang
          ]
          ++ lib.optionals (pkgs.stdenv.isLinux) [
            bluez
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

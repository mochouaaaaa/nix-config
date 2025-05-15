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
      devShells.luaenv = pkgs.mkShell rec {
        name = "luaenv-install";
        description = "luaenv install `Lua` development shell";
        nativeBuildInputs = with pkgs; [
          autoreconfHook
          pkg-config
          stdenv.cc
        ];
        buildInputs =
          with pkgs;
          [
            readline
          ]
          ++ lib.optionals (pkgs.stdenv.isDarwin) [
            clang
          ]
          ++ lib.optionals (pkgs.stdenv.isLinux) [
            gcc
          ];
        env = {
        };
        shellHook = ''
          echo -e "\033[1;32m==> Welcome to Luaenv install python development  ✅\033[0m"
        '';
      };
    };
}

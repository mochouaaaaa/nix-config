{
  flake.modules.homeManager.db-clients = { lib, pkgs, ... }: {

    home.packages = [
      pkgs.dbeaver-bin
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      pkgs.tiny-rdm
    ];

  };
}

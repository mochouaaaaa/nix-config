{
  flake.modules.homeManager.programs = { lib, pkgs, ... }: {

    home.packages =
      lib.optionals (!pkgs.stdenv.hostPlatform.isx86_64 && pkgs.stdenv.hostPlatform.isDarwin)
        [
          pkgs.wireshark
        ];

  };
}

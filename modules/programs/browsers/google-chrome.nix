{
  flake.aspects = {
    "desktop.programs".provides.browsers.provides."google-chrome".homeManager =
      { lib, pkgs, ... }:
      {
        home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          pkgs.google-chrome
        ];
      };

    "programs".darwin.homebrew.casks = [
      "google-chrome"
    ];
  };
}

{
  flake.aspects = { aspects, ... }: {
    darwin = {
      includes = [
        aspects."programs.mpv"
      ];

      homeManager = { lib, ... }: {
        programs.mpv.enable = lib.mkForce false;
      };
    };

    "programs".darwin = {
      homebrew.casks = [
        "iina"
        "iina+"
      ];
    };
  };
}

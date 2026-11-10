{ self, ... }: {

  flake.modules.homeManager.darwin = { lib, ... }: {
    imports = [
      self.modules.homeManager.programs-mpv
    ];

    programs.mpv.enable = lib.mkForce false;
  };

  flake.modules.darwin.programs = {
    homebrew.casks = [
      "iina"
      "iina+"
    ];
  };
}

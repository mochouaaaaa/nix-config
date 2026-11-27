{ self, ... }: {

  flake.aspects."darwin"."homeManager" = { lib, ... }: {
    imports = [
      self.modules.homeManager."programs.mpv"
    ];

    programs.mpv.enable = lib.mkForce false;
  };

  flake.aspects."programs"."darwin" = {
    homebrew.casks = [
      "iina"
      "iina+"
    ];
  };
}

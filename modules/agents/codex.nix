{
  flake.aspects."agents.codex".homeManager = { lib, pkgs, ... }: {
    programs.codex = {
      enable = true;
    }
    // lib.optionalAttrs (!pkgs.stdenv.hostPlatform.isDarwin) {
      mutableSettings = true;
    };
  };

  flake.aspects.preservation.nixos =
    {
      username,
      lib,
      config,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optional config.home-manager.users.${username}.programs.codex.enable
          ".config/codex";
    };
}

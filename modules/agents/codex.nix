{
  flake.modules.homeManager."agents.codex" = { lib, pkgs, ... }: {
    programs.codex = {
      enable = true;
    }
    // lib.optionalAttrs (!pkgs.stdenv.hostPlatform.isDarwin) {
      mutableSettings = true;
    };
  };

  flake.modules.nixos.preservation =
    {
      username,
      lib,
      config,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optional config.home-manager.users.${username}.programs.codex.enable
          ".codex";
    };
}

{
  flake.modules.homeManager."agents.codex" = {
    programs.codex.enable = true;
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

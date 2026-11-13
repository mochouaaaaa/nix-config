{
  flake.modules.homeManager."programs.codex" = {
    programs.codex.enable = true;
  };

  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".codex"
    ];
  };
}

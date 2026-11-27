{
  flake.aspects."desktop.base".nixos = {
    programs.uwsm = {
      enable = true;
    };
  };
}

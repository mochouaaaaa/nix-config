{
  flake.modules.nixos."desktop.base" = {
    programs.uwsm = {
      enable = true;
    };
  };
}

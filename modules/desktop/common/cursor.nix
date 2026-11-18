{
  flake.modules.homeManager."desktop.user" = { pkgs, ... }: {
    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}

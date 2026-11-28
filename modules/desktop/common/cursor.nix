{
  flake.aspects.desktop-user.homeManager = { pkgs, ... }: {
    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}

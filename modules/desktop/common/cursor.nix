{
  flake.modules.homeManager."desktop.common" = { pkgs, ... }: {

    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

  };
}

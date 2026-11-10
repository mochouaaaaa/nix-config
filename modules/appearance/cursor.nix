{
  flake.modules.homeManager.appearance = { pkgs, ... }: {

    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      hyprcursor = {
        enable = true;
      };
    };

  };
}

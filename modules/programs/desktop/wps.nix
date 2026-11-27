{
  flake.aspects."desktop.programs.office"."homeManager" = { pkgs, ... }: {
    home.packages = [
      pkgs.wpsoffice-cn
      # nur.repos.novel2430.wpsoffice-cn
      # nur.repos.rewine.ttf-wps-fonts
      # nur.repos.rewine.ttf-ms-win10
    ];
  };
}

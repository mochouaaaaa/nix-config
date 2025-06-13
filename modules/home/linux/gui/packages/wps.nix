{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nur.repos.novel2430.wpsoffice-cn
    nur.repos.rewine.ttf-wps-fonts
    # nur.repos.rewine.ttf-ms-win10
  ];
}

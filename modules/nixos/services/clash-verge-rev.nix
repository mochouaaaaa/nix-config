{ pkgs, ... }:
{
  programs.clash-verge = {
    enable = true;
  };

  services.mihomo = {
    enable = false;
    tunMode = true;
    configFile = "/home/mochou/.local/share/io.github.clash-verge-rev.clash-verge-rev";
  };
}

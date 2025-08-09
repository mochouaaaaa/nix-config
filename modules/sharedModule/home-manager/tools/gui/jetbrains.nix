{ pkgs, self, ... }:
{
  home.packages = [
#    self.packages.${pkgs.system}.jetbra-free
  ];
}

{ pkgs, myvars, ... }:
{
  boot.loader.grub.theme = pkgs.sleek-grub-theme.override {
    withBanner = ''Hello ${myvars.username}'';
    withStyle = "bigSur";
  };
}

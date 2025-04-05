{ self, pkgs, ... }:
{
  # https://github.com/vinceliuice/grub2-themes
  boot.loader.grub.theme = pkgs.sleek-grub-theme.override {
    withBanner = ''Hello ${self.myvars.username}'';
    withStyle = "bigSur";
  };
}

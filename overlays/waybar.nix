args@{ inputs, pkgs, ... }:
(_: super: {
  waybar_git = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar;
})

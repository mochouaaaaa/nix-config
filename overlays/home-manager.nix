{ inputs, ... }:
final: prev:
inputs.nur.overlays.default final prev
// {
  waybar_git = inputs.waybar.packages.${final.pkgs.stdenv.hostPlatform.system}.waybar;

}

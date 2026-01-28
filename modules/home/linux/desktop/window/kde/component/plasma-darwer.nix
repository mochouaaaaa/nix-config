{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.kde;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.mochou_nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.kdeExtensions.plasma-darwer
    ];
  };
}

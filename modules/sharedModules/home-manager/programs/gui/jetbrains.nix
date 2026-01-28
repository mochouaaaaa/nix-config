{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.packages = [
      inputs.mochou_nur.packages.${pkgs.stdenv.hostPlatform.system}.jetbra-free
    ];

  };
}

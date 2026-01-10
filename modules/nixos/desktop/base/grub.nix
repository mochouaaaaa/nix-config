{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.grub2-themes.nixosModules.default
  ];

  config = lib.mkIf (config.profiles.desktop.enable) {

    boot.loader.grub = rec {
      fontSize = 16;
      font = "${pkgs.maple-mono.NF}/share/fonts/truetype/MapleMono-NF-Regular.ttf";
      gfxmodeEfi = lib.mkForce "1920x1080";
      gfxmodeBios = gfxmodeEfi;
    };

    boot.loader.grub2-theme = {
      enable = true;
      theme = "stylish";
      footer = true;
      customResolution = "1920x1080"; # Optional: Set a custom resolution
    };

  };
}

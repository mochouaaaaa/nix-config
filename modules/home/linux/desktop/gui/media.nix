{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (config.profiles.desktop.enable) {

    home.packages = with pkgs; [
      # audio control
      pavucontrol
      playerctl
      # pulsemixer
    ];

    programs.cava = {
      enable = true;
      settings = {
        general.framerate = 60;
        input = {
          method = "pipewire";
          source = "auto";
        };
        smoothing.noise_reduction = 88;
      };
    };
    xdg.configFile."cava/config".force = true;

    services = {
      playerctld.enable = config.programs.cava.enable;
    };

  };
}

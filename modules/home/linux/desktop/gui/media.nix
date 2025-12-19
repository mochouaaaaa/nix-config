{
  lib,
  pkgs,
  config,
  ...
}:
{

  config = lib.mkIf (config.programs.desktop.enable) {

    home.packages = with pkgs; [
      # audio control
      pavucontrol
      playerctl
      pulsemixer

      # video/audio tools
      libva-utils
      vdpauinfo
      vulkan-tools
      # glxinfo
      mesa-demos
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

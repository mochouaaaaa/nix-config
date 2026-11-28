{
  flake.aspects."desktop.programs".provides.audio.provides.tools.homeManager = { pkgs, ... }: {

    home.packages = with pkgs; [
      pavucontrol
      playerctl
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

    services.playerctld.enable = true;

  };
}

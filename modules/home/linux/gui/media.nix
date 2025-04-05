{
  pkgs,
  pkgs-unstable,
  ...
}:
# media - control and enjoy audio/video
let
  cavaTheme = pkgs.fetchgit {
    url = "https://github.com/catppuccin/cava";
    hash = "sha256-5AQcCRGaAxP5KFzkJtkKFYq0Ug2xVIEqr2r/k87uWwY=";
  };
in {
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    imv # simple image viewer

    #    nvtopPackages.full

    # video/audio tools
    cava # for visualizing audio
    libva-utils
    vdpauinfo
    vulkan-tools
    glxinfo
  ];

  # https://github.com/catppuccin/cava
  xdg.configFile."cava/config".text =
    ''
      # custom cava config
    ''
    + builtins.readFile
    "${cavaTheme}/themes/mocha.cava";

  services = {playerctld.enable = true;};
}

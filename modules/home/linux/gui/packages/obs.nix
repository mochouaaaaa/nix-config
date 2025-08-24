{
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  ...
}:
{
  config = {
    home.packages = with pkgs; [
      # creative
      blender # 3d modeling
      # gimp      # image editing, I prefer using figma in browser instead of this one
      inkscape # vector graphics
      krita # digital painting
      musescore # music notation
      go-musicfox
      # reaper # audio production
      # sonic-pi # music programming

      # this app consumes a lot of storage, so do not install it currently
      # kicad     # 3d printing, eletrical engineering

      # fpga
      pkgs-stable.python312Packages.apycula # gowin fpga
      pkgs-stable.yosys # fpga synthesis
      pkgs-stable.nextpnr # fpga place and route
      pkgs-stable.openfpgaloader # fpga programming
    ];

    programs = {
      # live streaming
      obs-studio = {
        enable = true;
        package = pkgs-stable.obs-studio;
        plugins = with pkgs-stable.obs-studio-plugins; [
          # screen capture
          wlrobs
          obs-ndi
          obs-vaapi
          # obs-nvfbc
          obs-teleport
          obs-hyperion
          droidcam-obs
          obs-vkcapture
          obs-gstreamer
          obs-3d-effect
          obs-multi-rtmp
          obs-source-clone
          obs-shaderfilter
          obs-source-record
          obs-livesplit-one
          looking-glass-obs
          obs-vintage-filter
          obs-command-source
          obs-move-transition
          obs-backgroundremoval
          advanced-scene-switcher
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}

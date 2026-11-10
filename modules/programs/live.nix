{
  flake.modules.homeManager."desktop.common" =
    {
      pkgs,
      ...
    }:
    {

      home.packages = with pkgs; [
        kooha

        hypnotix
        piliplus
      ];

      programs.obs-studio = {
        enable = true;
        package = pkgs.obs-studio;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
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

  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".config/obs-studio"
      ".local/share/com.example.piliplus"
    ];
  };

}

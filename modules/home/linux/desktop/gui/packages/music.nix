{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.packages.tencent;
  isDesktop = config.profiles.desktop.enable;
  cfgDesktop = config.profiles.desktop;
in
{

  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  config = lib.mkIf isDesktop (
    lib.mkMerge [

      {
        programs.spicetify =
          let
            spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
          in
          {
            enable = true;
            # wayland = true;
            enabledExtensions = with spicePkgs.extensions; [
              adblock
              adblockify
              autoSkipVideo
              hidePodcasts
              shuffle
              fullAppDisplay
            ];
            # theme = spicePkgs.themes.starryNight;
            theme = spicePkgs.themes.turntable;
          };

        home.packages = with pkgs; [
          splayer
          # spotify
          # (spicetify-cli.overrideAttrs (oldAttrs: {
          #   postInstall = oldAttrs.postInstall + ''
          #     cp -rf $src/Extensions $out/share/spicetify
          #   '';
          # }))
        ];
      }

      (lib.mkIf (cfgDesktop.hyprland.enable) {
        wayland.windowManager.hyprland = {
          settings = {
            bind = [
              "$mod CTRL, 1, togglespecialworkspace, music"
            ];
            windowrule = [
              "workspace special:music, match:class feishin|Spotify|Supersonic|SPlayer"
              "workspace special:music, match:initial_title Spotify( Free)?" # Spotify wayland, it has no class for some reason
            ];
          };
        };
      })

    ]
  );

}

{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  isDesktop = config.profiles.desktop.enable;
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
    ]
  );

}

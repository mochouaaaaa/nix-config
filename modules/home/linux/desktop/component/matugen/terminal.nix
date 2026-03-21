{ lib, config, ... }:
let
  cfgMatugen = config.programs.matugen;

  cfgNoctalia = config.programs.noctalia-shell;
  cfgDarkMaterial = config.programs.dank-material-shell;

  useNoctaliaKitty = cfgNoctalia.enable;
  useDarkMaterial = cfgDarkMaterial.enable;
in
{
  config = lib.mkIf (cfgMatugen.enable) (
    lib.mkMerge [
      {
        profiles.packages.terminal.kitty.extraConfig = lib.mkMerge [

          (lib.mkIf useNoctaliaKitty (lib.mkAfter [ "include themes/noctalia.conf" ]))

          (lib.mkIf useDarkMaterial (
            lib.mkAfter [
              "include dank-tabs.conf"
              "include dank-theme.conf"
            ]
          ))

        ];
      }

      {
        programs.ghostty.settings = lib.mkMerge [

          (lib.mkIf useDarkMaterial {
            theme = "dankcolors";
            app-notifications = "no-clipboard-copy,no-config-reload";
          })

        ];
      }
    ]
  );
}

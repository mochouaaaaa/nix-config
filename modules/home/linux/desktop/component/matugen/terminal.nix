{ lib, config, ... }:
let
  cfgMatugen = config.programs.matugen;

  cfgNoctalia = config.modules'.desktop.shell.noctalia;
  cfgDarkMaterial = config.programs.dankMaterialShell;

  useNoctaliaKitty = cfgNoctalia.enable && cfgNoctalia.settings.templates.kitty;
  useNoctaliaGhostty = cfgNoctalia.enable && cfgNoctalia.settings.templates.ghostty;
  useDarkMaterial = cfgDarkMaterial.enable;
in
{
  config = lib.mkIf (cfgMatugen.enable) (
    lib.mkMerge [
      {
        modules'.packages.terminal.kitty.extraConfig = lib.mkMerge [
          (lib.mkIf useNoctaliaKitty (lib.mkAfter [ "include current-theme.conf" ]))
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
          (lib.mkIf useNoctaliaGhostty {
            theme = "noctalia";
          })
          (lib.mkIf useDarkMaterial {
            theme = "dankcolors";
            app-notifications = "no-clipboard-copy,no-config-reload";
          })
        ];
      }
    ]
  );
}

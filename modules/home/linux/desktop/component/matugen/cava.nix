{ lib, config, ... }:
let
  cfgCava = config.programs.cava;
  cfgMatugen = config.programs.matugen;
  cfgNoctalia = config.programs.noctalia-shell;
  cfgDarkMaterial = config.programs.dankMaterialShell;
in
{
  config = lib.mkIf (cfgCava.enable && cfgMatugen.enable) (
    lib.mkMerge [
      (lib.mkIf (cfgNoctalia.enable) {
        programs.cava.settings = {
          color.theme = "noctalia";
        };
      })

      (lib.mkIf (cfgDarkMaterial.enable) {
        programs.cava.settings = {
          color.theme = "matugen";
        };
        xdg.configFile = {
          "matugen/templates/cava.ini".text = ''
            [color]
            background = 'default'
            foreground = '{{colors.primary.default.hex}}'

            gradient = 1
            gradient_color_1 = '{{colors.primary_container.default.hex}}'
            gradient_color_2 = '{{colors.primary.default.hex}}'
            gradient_color_3 = '{{colors.on_primary_container.default.hex}}'

            horizontal_gradient = 0
            horizontal_gradient_color_1 = '{{colors.primary_container.default.hex}}'
            horizontal_gradient_color_2 = '{{colors.primary.default.hex}}'
            horizontal_gradient_color_3 = '{{colors.on_primary_container.default.hex}}'
            horizontal_gradient_color_4 = '{{colors.primary.default.hex}}'
            horizontal_gradient_color_6 = '{{colors.primary_container.default.hex}}'
          '';
        };
      })
    ]
  );
}

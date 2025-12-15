{ lib, config, ... }:
let
  cfg = config.modules'.desktop.shell.noctalia;
in
{
  config = lib.mkIf (cfg.enable && cfg.settings.templates.tmux) {

    programs.noctalia-shell.user-templates = {
      templates = {
        tmux = {
          inputPath = "${config.xdg.configHome}/noctalia/colorschemes/tmux.conf";
          outputPath = "${config.xdg.configHome}/tmux/generated.conf";
          postHook = "tmux source-file ${config.xdg.configHome}/tmux/generated.conf";
        };
      };
    };

    xdg.configFile = {
      "noctalia/colorschemes/tmux.conf".text = ''
        set -gq @thm_bg                           "{{colors.surface.default.hex}}"
        set -gq @thm_fg                           "{{colors.on_surface.default.hex}}"
        set -gq @thm_primary                      "{{colors.primary.default.hex}}"
        set -gq @thm_inverse_primary              "{{colors.inverse_primary.default.hex}}"
        set -gq @thm_surface_low                  "{{colors.surface_container_low.default.hex}}"
        set -gq @thm_surface                      "{{colors.surface_container.default.hex}}"
        set -gq @thm_surface_variant              "{{colors.surface_container_high.default.hex}}"
        set -gq @thm_outline                      "{{colors.outline_variant.default.hex}}"
        set -gq @thm_text_variant                 "{{colors.on_surface_variant.default.hex}}"
      '';
    };
  };
}

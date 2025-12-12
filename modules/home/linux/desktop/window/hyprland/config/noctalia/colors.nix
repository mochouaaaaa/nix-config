{
  lib,
  config,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{
  config = lib.mkIf (cfgHyprland.enable && cfgNoctalia.enable) {

    xdg.configFile = {
      "noctalia/colorschemes/hyprland-colors.conf".text = ''
        <* for name, value in colors *>
        $image = {{image}}
        ''${{name}} = rgba({{value.default.hex_stripped}}ff)
        <* endfor *>
      '';
    };

    programs.noctalia-shell.user-templates = {
      templates = {
        hyprland = {
          inputPath = "${config.xdg.configHome}/noctalia/colorschemes/hyprland-colors.conf";
          outputPath = "${config.xdg.configHome}/hypr/colors.conf";
          postHook = "hyprland reload";
        };
      };
    };

    wayland.windowManager.hyprland = {
      extraConfig = ''
        source = colors.conf
      '';
    };

  };
}

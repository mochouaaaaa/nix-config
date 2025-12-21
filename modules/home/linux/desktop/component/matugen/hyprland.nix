{
  lib,
  config,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
  cfgMatugen = config.programs.matugen;
in
{
  config = lib.mkIf (cfgHyprland.enable && cfgMatugen.enable) (
    lib.mkMerge [
      {
        xdg.configFile = {
          "matugen/templates/hyprland-colors.conf".text = ''
            <* for name, value in colors *>
            $image = {{image}}
            ''${{name}} = rgba({{value.default.hex_stripped}}ff)
            <* endfor *>
          '';
        };

        wayland.windowManager.hyprland = {
          settings = {
            source = [ "colors.conf" ];
            general = lib.mkForceRecursive {
              "col.active_border" = "$primary";
              "col.inactive_border" = "$surface_variant";
              "col.nogroup_border" = "$surface_variant";
              "col.nogroup_border_active" = "$primary_fixed_dim";
            };
            group = lib.mkForceRecursive {
              "col.border_active" = "$primary";
              "col.border_inactive" = "$surface_variant";
              "col.border_locked_active" = "$primary";
              "col.border_locked_inactive" = "$surface_variant";

              groupbar = {
                "col.active" = "$primary";
                "col.inactive" = "$outline_variant";
                "col.locked_active" = "$primary";
                "col.locked_inactive" = "$secondary";
                text_color = "$on_primary";
              };
            };
            misc = lib.mkForceRecursive {
              background_color = "$background";
            };
            decoration = {
              shadow.color = lib.mkForce "$shadow";
            };

          };
        };
      }
    ]
  );
}

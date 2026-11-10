{
  flake.modules.homeManager."desktop.hyprland" = { lib, ... }: {
    wayland.windowManager.hyprland.settings.bind = [
      {
        _args = [
          "SUPER + SPACE"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae toggle\")")
        ];
      }
      {
        _args = [
          "SUPER + P"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae vicinae://launch/clipboard/history\")")
        ];
      }
    ];
  };

  flake.modules.homeManager."desktop.niri" = {
    wayland.windowManager.niri.settings.binds = {
      "Mod+SPACE" = {
        _props = {
          allow-inhibiting = false;
          repeat = false;
        };
        spawn-sh = [ "vicinae toggle" ];
      };
      "Mod+P" = {
        _props = {
          allow-inhibiting = false;
          repeat = false;
        };
        spawn-sh = [ "vicinae vicinae://launch/clipboard/history" ];
      };

    };
  };

}

{
  flake.modules.homeManager."desktop.hyprland" = { lib, ... }: {
    programs.vicinae = {
      systemd = {
        enable = lib.mkForce false;
      };
    };

    wayland.windowManager.hyprland = {
      settings.bind = [
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

      extraConfig = ''
        hl.on("hyprland.start", function()
            hl.exec_cmd("vicinae server")
        end)

        hl.layer_rule {
        	name = "vicinae",
        	match = {
        		namespace = "vicinae",
        	},
        	blur = true,
        	ignore_alpha = 0,
        }

      '';
    };
  };

}

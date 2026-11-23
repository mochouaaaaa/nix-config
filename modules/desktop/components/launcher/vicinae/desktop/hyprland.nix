{
  flake.modules.homeManager."desktop.hyprland" = {

    wayland.windowManager.hyprland = {
      extraConfig = ''
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

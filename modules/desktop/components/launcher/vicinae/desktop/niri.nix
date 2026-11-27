{
  flake.aspects."desktop.niri".homeManager = _: {
    # programs.vicinae = {
    #   systemd = {
    #     enable = lib.mkForce false;
    #   };
    # };

    wayland.windowManager.niri.settings = {
      debug = {
        honor-xdg-activation-with-invalid-serial = { };
      };
      binds = {
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

      _children = [
        # {
        #   spawn-at-startup = [
        #     "vicinae"
        #     "server"
        #   ];
        # }
        {
          layer-rule._children = [
            { match._props.namespace = "vicinae"; }
            {
              place-within-backdrop = true;
              background-effect = {
                blur = true;
                xray = false;
              };
            }
          ];
          window-rule._children = [
            { match._props.app-id = "vicinae"; }
            { open-floating = true; }
          ];
        }

      ];
    };

  };
}

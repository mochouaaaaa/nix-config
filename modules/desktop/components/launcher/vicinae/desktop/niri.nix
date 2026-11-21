{
  flake.modules.homeManager."desktop.niri" = {

    wayland.windowManager.niri.settings = {
      _children = [
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
        }

      ];
    };

  };
}

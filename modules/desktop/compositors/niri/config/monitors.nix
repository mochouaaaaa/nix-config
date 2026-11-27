{
  flake.aspects."desktop.niri".homeManager = {

    wayland.windowManager.niri.settings = {
      _children = [
        {
          output = {
            _args = [ "LG Electronics LG HDR 4K 0x00052C1D" ];

            mode = {
              _args = [ "3840x2160@59.951" ];
            };

            scale = 1.5;
            variable-refresh-rate._args = [ ];
          };
        }
      ];
    };

  };
}

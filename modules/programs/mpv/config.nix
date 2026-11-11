{

  flake.modules.homeManager."desktop.common" =
    {
      self,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.modules.homeManager.programs-mpv
      ];

      programs = {
        mpv = {
          scripts = [
            pkgs.mpvScripts.mpris
          ];
        };
        imv = {
          enable = true;
          settings = {
            binds = {
              "<h>" = "prev";
              "<l>" = "next";
              "<j>" = "zoom -1";
              "<k>" = "zoom 1";
              "<Space>" = "next";

              "<0>" = "zoom actual";

              "<f>" = "fullscreen";
              "<r>" = "rotate by 90";
            };
          };
        };
      };
      xdg.mimeApps.defaultApplicationPackages = [
        config.programs.mpv.package
        config.programs.imv.package
      ];

    };

  flake.modules.homeManager.programs-mpv = { pkgs, ... }: {

    programs.mpv = {
      enable = true;

      defaultProfiles = [ "gpu-hq" ];
      config = {
        osc = "no";
      };
      bindings = {
        WHEEL_LEFT = "seek 30";
        WHEEL_RIGHT = "seek -30";
        UP = "add volume +5";
        DOWN = "add volume -5";
      };
      extraInput = ''
        esc         quit                        #! Quit
      '';
      scripts = [
        pkgs.mpvScripts.modernz
      ];
    };

  };

}

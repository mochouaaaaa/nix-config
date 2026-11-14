{
  flake.modules.homeManager."desktop.hyprland" =
    {
      lib,
      pkgs,
      self,
      inputs,
      config,
      ...
    }:
    {

      imports = [
        self.modules.homeManager."desktop.shell.noctalia"
      ];

      services.cliphist.enable = true;

      programs = {
        swappy = {
          enable = false;
          settings = {
            Default = {
              save_dir = "$XDG_PICTURES_DIR/Screenshots";
            };
          };
        };
      };

      home.packages = with pkgs; [
        libnotify
        wl-clipboard-rs
      ];

      xdg.configFile = {
        "hypr/.luarc.json".text = ''
          {
            "workspace": {
              "library": [
                "${pkgs.hyprland}/share/hypr/stubs"
              ]
            },
            "diagnostics": {
               "globals": [
                  "hl"
               ]
            }
          }
        '';
      }
      // config.profiles.dotfileLink "hypr";

      wayland.systemd.target = "hyprland-session.target";
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd = {
          enable = true;
          variables = [ "--all" ];
          enableXdgAutostart = true;
        };
        plugins = [
          inputs.hyprcapture.packages.${pkgs.stdenv.hostPlatform.system}.hyprcapture
        ];
        configType = "lua";
        extraConfig = lib.mkBefore ''
          require("init")

          hl.config({
              render = {
                  cm_auto_hdr = 1,
              },
              cursor = {
                  no_hardware_cursors = false;
                  enable_hyprcursor = true;
                  -- warp_on_change_workspace = true;
                  -- no_warps = true;
              };
          })
        '';
      };

    };
}

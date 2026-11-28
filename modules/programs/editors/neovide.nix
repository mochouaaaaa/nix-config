{

  flake.aspects.darwin.homeManager = { lib, ... }: {
    programs.neovide.package = null;
    programs.neovide.settings = {
      frame = lib.mkForce "transparent";
    };
  };

  flake.aspects.editors.provides.neovide.homeManager =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      fontFamily = config.profiles.fonts.default or "Monaco Nerd Font";
    in
    {
      programs.neovide = {
        enable = false;
        settings = {
          fork = true;
          frame = "none";
          idle = true;
          maximized = false;
          neovim-bin = "${config.programs.neovim.package}/bin/nvim";
          no-multigrid = false;
          srgb = true;
          tabs = true;
          theme = "auto";
          mouse-cursor-icon = "arrow";
          title-hidden = true;
          vsync = true;
          wsl = false;
          font = {
            normal = [ fontFamily ]; # Will use the bundled Fira Code Nerd Font by default
            size = 17;
          };
          box-drawing = {
            mode = "native";
          };
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          wayland-app-id = "org.neovim.Neovide";
        };
      };
    };

  flake.aspects.desktop-niri.homeManager = {
    wayland.windowManager.niri.settings = {
      _children = [
        {
          window-rule._children = [
            {
              match._props.app-id = "^(neovide)$";
            }
            { opacity = 0.85; }
          ];
        }
      ];
    };
  };
}

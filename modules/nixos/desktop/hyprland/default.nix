{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  cfgHyprland = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.getEnv "DESKTOP" == "hyprland";
      description = "Enable Hyprland desktop environment.";
    };
  };
  config = lib.mkIf cfgHyprland.enable {

    modules.dm.greetd.enable = true;

    programs = {
      hyprland = {
        enable = true;
        # withUWSM = true;
        # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };

      regreet = {
        enable = true;
      };

      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

    environment.systemPackages = with pkgs; [
      cage

      turtle # nautilus plugin
      nautilus
    ];

    services = {
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
      };
      xserver = {
        enable = true;
      };
      greetd = {
        settings = {
          default_session = {
            user = self.myvars.username;
            #command = lib.mkForce "cage -s -mlast ${lib.getExe config.programs.regreet.package}";
            # command = lib.mkForce "${lib.getExe config.programs.hyprland.package}";
            command = lib.mkForce "$HOME/.wayland-session";
          };
        };
      };
    };
  };
}

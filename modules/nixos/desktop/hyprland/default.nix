{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}:
let
  cfgHyprland = config.modules'.desktop.hyprland;
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf cfgHyprland.enable {

    modules.dm.greetd.enable = true;

    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      };

      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    };

    environment = {
      systemPackages = with pkgs; [
        turtle # nautilus plugin
        nautilus
      ];
    };

    programs.ssh.startAgent = lib.mkForce false;

    services = {
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
      };
      greetd = {
        settings = {
          default_session = {
            user = username;
            command = lib.mkForce "${lib.getExe config.programs.hyprland.package}";
          };
        };
      };
    };
  };
}

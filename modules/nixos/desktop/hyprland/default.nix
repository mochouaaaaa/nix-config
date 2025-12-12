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
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
        (pkgs.writeShellApplication {
          name = "launch-hyprland";
          text = ''
            # systemd-cat --identifier hyprland Hyprland
            Hyprland 2>&1 | systemd-cat -t hyprland
          '';
        })
      ];
    };

    programs.ssh.startAgent = lib.mkForce false;

    services = {
      greetd = {
        settings = rec {
          default_session = {
            user = username;
            # command = lib.mkForce "${lib.getExe config.programs.hyprland.package}";
            command = lib.mkForce "Hyprland 2>&1 | systemd-cat -t hyprland";
          };
          initial_session = default_session;
        };
      };
    };
  };
}

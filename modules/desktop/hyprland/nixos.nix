{
  flake.modules.nixos."desktop.hyprland" =
    {
      self,
      lib,
      pkgs,
      inputs,
      config,

      username,
      ...
    }:
    let
      nixosHyprland = config.programs.hyprland;
    in
    {
      imports = [
        self.modules.nixos."desktop.common"
      ];

      programs.hyprland = {
        enable = true;
        # package = pkgs.hyprland;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        withUWSM = false;
      };

      # Import the matching Home Manager desktop only for this host's primary user.
      # The NixOS and HM module classes remain separate; this module composes them.
      home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
        self.modules.homeManager."desktop.hyprland"
        (
          { lib, config, ... }:
          {
            config = lib.mkIf nixosHyprland.enable (
              lib.mkMerge [
                {
                  wayland.windowManager.hyprland = {
                    package = lib.mkForce null;
                    portalPackage = lib.mkForce null;
                    systemd.enable = lib.mkForce (!nixosHyprland.withUWSM);
                  };

                  xdg.portal.extraPortals = [ nixosHyprland.portalPackage ];
                }

                (lib.mkIf nixosHyprland.withUWSM {
                  wayland.systemd.target = lib.mkForce "graphical-session.target";

                  xdg.configFile."uwsm/env" = {
                    enable = true;
                    source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
                  };
                })
              ]
            );
          }
        )
      ];
    };
}

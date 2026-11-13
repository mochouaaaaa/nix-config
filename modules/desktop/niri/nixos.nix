{
  flake.modules.nixos."desktop.niri" =
    {
      config,
      lib,
      self,
      username,
      ...
    }:
    let
      nixosNiri = config.programs.niri;
    in
    {
      imports = [
        self.modules.nixos."desktop.common"
      ];

      programs.niri = {
        enable = true;
        useNautilus = true;
      };

      # Compose the matching Home Manager desktop only for the primary user.
      home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
        self.modules.homeManager."desktop.niri"
        ({ lib, ... }: {
          wayland.windowManager.niri.package = lib.mkForce nixosNiri.package;
        })
      ];
    };
}

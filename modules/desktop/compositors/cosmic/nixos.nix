{
  flake.modules.nixos."desktop.cosmic" =
    {
      self,
      lib,
      config,
      pkgs,
      username,
      ...
    }:
    {
      imports = [
        self.modules.nixos."desktop.common"
      ];

      services.desktopManager.cosmic.enable = true;

      services.displayManager.cosmic-greeter.enable = true;

      environment.cosmic.excludePackages = with pkgs; [
        cosmic-term
        cosmic-store
        cosmic-edit
      ];

      home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
        self.modules.homeManager."desktop.cosmic"
      ];

    };
}

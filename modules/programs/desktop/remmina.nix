{

  flake.modules.homeManager."desktop.programs.remote" = {
    services.remmina = {
      enable = true;
      systemdService = {
        enable = false;
      };
    };
  };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.services.remmina.enable
          [
            # ======================================
            # Remote
            # ======================================
            ".config/remmina"
            ".local/share/remmina"
          ];
    };

}

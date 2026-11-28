{

  flake.aspects."desktop.programs".provides.remote.provides.remmina.homeManager = {
    services.remmina = {
      enable = true;
      systemdService = {
        enable = false;
      };
    };
  };

  flake.aspects.preservation.nixos =
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

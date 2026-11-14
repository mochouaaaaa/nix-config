{
  flake.modules.nixos."programs.evolution" =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    {
      programs.evolution = {
        enable = true;
        plugins = [ pkgs.evolution-ews ];
      };

      profiles.preservation.users.${username}.directories =
        lib.optionals config.programs.evolution.enable
          [
            ".config/evolution"
            ".local/share/evolution"
            ".cache/evolution"
          ];
    };

}

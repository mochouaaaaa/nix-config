{
  flake.aspects."programs.evolution"."nixos" =
    {
      pkgs,
      ...
    }:
    {
      programs.evolution = {
        enable = true;
        plugins = [ pkgs.evolution-ews ];
      };
    };

  flake.aspects."preservation"."nixos" =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.programs.evolution.enable
          [
            ".config/evolution"
            ".local/share/evolution"
            ".cache/evolution"
          ];
    };
}

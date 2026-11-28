{
  flake.aspects = { aspects, ... }: {
    desktop-programs.provides.email.provides.evolution = {
      includes = [ aspects."programs.evolution" ];
      nixos = _: { };
    };

    "programs.evolution".nixos =
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

    preservation.nixos =
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
  };
}

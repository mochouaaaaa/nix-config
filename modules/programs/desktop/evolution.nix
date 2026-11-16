{
  flake.modules.nixos."programs.evolution" =
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

  flake.modules.nixos.preservation =
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

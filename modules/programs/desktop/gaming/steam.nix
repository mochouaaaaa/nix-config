{
  flake.modules.nixos."desktop.programs.gaming" =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.programs.steam.enable [
          ".local/share/Steam"
          ".steam"
        ];

      hardware.steam-hardware.enable = true;

      programs.steam = {
        enable = true;
        gamescopeSession.enable = false;
        fontPackages = [ pkgs.wqy_zenhei ];
        protontricks.enable = true;

        # Use extraPackages to extend the FHS environment.
        extraPackages = with pkgs; [
          source-sans
          source-serif
          source-han-sans
          source-han-serif
          pipewire
          libkrb5
          keyutils
        ];
      };
    };
}

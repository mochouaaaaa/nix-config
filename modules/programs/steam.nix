{

  flake.modules.nixos.programs-steam =
    {
      lib,
      pkgs,
      config,

      username,
      ...
    }:
    {

      profiles.preservation.users.${username}.directories = lib.optionals config.programs.steam [
        ".local/share/Steam"
        ".steam"
      ];

      hardware.steam-hardware.enable = true;

      # https://wiki.archlinux.org/title/steam
      # Games installed by Steam works fine on NixOS, no other configuration needed.
      programs.steam = {
        # Some location that should be persistent:
        #   ~/.local/share/Steam - The default Steam install location
        #   ~/.local/share/Steam/steamapps/common - The default Game install location
        #   ~/.steam/root        - A symlink to ~/.local/share/Steam
        #   ~/.steam             - Some Symlinks & user info
        enable = true;
        gamescopeSession.enable = false;

        fontPackages = [ pkgs.wqy_zenhei ];

        protontricks.enable = true;

        # 用 extraPackages 补充 FHS 环境，而不是 override 整个 package
        extraPackages = with pkgs; [
          # fix CJK fonts
          source-sans
          source-serif
          source-han-sans
          source-han-serif

          # audio
          pipewire

          # 其他确实需要补充的库
          libkrb5
          keyutils
        ];
      };

    };

}

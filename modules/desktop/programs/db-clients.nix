{
  flake.modules.homeManager."desktop.programs.database" =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      tiny-rdm = pkgs.symlinkJoin {
        name = "tiny-rdm";
        paths = [ pkgs.tiny-rdm ];

        nativeBuildInputs = [ pkgs.makeWrapper ];

        postBuild = ''
          wrapProgram $out/bin/tiny-rdm \
            --set GDK_BACKEND x11 \
            --set GDK_DPI_SCALE 1.5
        '';
      };

      cfg = config.profiles.database-clients;
    in
    {
      options.profiles.database-clients.enable = lib.mkEnableOption "desktop database clients";

      config = lib.mkIf cfg.enable {
        home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          pkgs.dbeaver-bin
          tiny-rdm
        ];
      };
    };

  # Keep the NixOS-specific persistence integration separate from installing
  # GUI applications. The Home Manager workstation role owns the clients.
  flake.modules.nixos."desktop.programs.database" =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.profiles.database-clients.enable
          [
            ".config/TinyRDM"
          ];
    };
}

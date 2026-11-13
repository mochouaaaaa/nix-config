{
  flake.modules.homeManager."programs.db-clients" =
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

      cfg = config.profiles.database-cli;
    in
    {

      options.profiles.database-cli = {
        enable = lib.mkEnableOption "db clients";
      };

      config = lib.mkIf cfg.enable {

        home.packages = [
          pkgs.dbeaver-bin
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          tiny-rdm
        ];
      };
    };

  # flake.modules.homeManager."desktop-common" = { self, ... }: {
  #   profiles.database-cli.enable = true;
  #   imports = [ self.modules.homeManager."programs.db-clients" ];
  # };

  flake.modules.nixos."desktop.common" =
    {
      self,
      lib,
      config,
      username,
      ...
    }:
    {

      home-manager.users.${username}.imports = lib.optionals (config ? home-manager) [
        { profiles.database-cli.enable = true; }
        self.modules.homeManager."programs.db-clients"
      ];

      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.profiles.database-cli.enable
          [
            ".config/TinyRDM"
          ];
    };

}

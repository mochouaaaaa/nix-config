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

  # NixOS-side toggle for hosts that expose the database-client role.
  # The Home Manager module itself is imported by the workstation role.
  flake.modules.nixos."desktop.programs.database" =
    { username, ... }:
    {
      home-manager.users.${username}.profiles.database-clients.enable = true;
    };

  # Persistence is an optional integration, not a dependency of the
  # database-client module itself.
  flake.modules.nixos.preservation =
    {
      lib,
      config,
      options,
      username,
      ...
    }:
    let
      hasHomeManager = options ? home-manager;
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (
          hasHomeManager
          && config.home-manager.users.${username}.profiles.database-clients.enable
        ) [
          ".config/TinyRDM"
        ];
    };
}

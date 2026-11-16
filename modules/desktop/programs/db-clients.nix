{
  flake.modules.homeManager."desktop.programs.database" =
    {
      lib,
      pkgs,
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
    in
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.dbeaver-bin
        tiny-rdm
      ];
    };

  # Keep application data persistent independently of the Home Manager
  # module's import graph.
  flake.modules.nixos.preservation =
    { username, ... }:
    {
      profiles.preservation.users.${username}.directories = [
        ".config/TinyRDM"
      ];
    };
}

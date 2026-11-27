let
  mkTinyRdm =
    pkgs:
    pkgs.symlinkJoin {
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
  flake.aspects."desktop.programs.database".homeManager =
    {
      lib,
      pkgs,
      ...
    }:
    let
      tiny-rdm = mkTinyRdm pkgs;
    in
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pkgs.dbeaver-bin
        tiny-rdm
      ];
    };

  # Preserve TinyRDM data only when its package is in the user's effective
  # Home Manager package set.
  flake.aspects."preservation".nixos =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages or [ ];
      tiny-rdm = mkTinyRdm pkgs;
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem tiny-rdm homePackages)
          [
            ".config/TinyRDM"
          ];
    };
}

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

  # Preserve TinyRDM data only when the application is part of the user's
  # effective Home Manager package set.
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
      homePackages = config.home-manager.users.${username}.home.packages;
      hasTinyRdm = lib.any (package: lib.getName package == "tiny-rdm") homePackages;
    in
    {
      config = lib.mkIf (hasHomeManager && hasTinyRdm) {
        profiles.preservation.users.${username}.directories = [
          ".config/TinyRDM"
        ];
      };
    };
}

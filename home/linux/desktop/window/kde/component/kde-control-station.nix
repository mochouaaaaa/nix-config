{pkgs, ...}: let
  kde-control-station = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "kde-control-station";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "kde-control-station";
      rev = "plasma6";
      sha256 = "sha256-rm3DO56rCtB/1Ubpb+3/kLA6xYlsyk7CoETzFGncvcw=";
    };

    propagatedUserEnvPkgs = with pkgs.kdePackages; [
      plasma-nm
      kdeplasma-addons
      plasma-pa
      powerdevil
      kdeconnect-kde
    ];

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plasma/plasmoids/KdeControlStation
      cp -r package/* $out/share/plasma/plasmoids/KdeControlStation
      runHook postInstall
    '';

    passthru.updateScript = pkgs.nix-update-script {};
  };
in {
  home.packages = [kde-control-station];
}

{pkgs, ...}: let
  thermal-monitor = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "thermal-monitor";
    version = "v0.2.5";

    src = pkgs.fetchFromGitHub {
      owner = "olib14";
      repo = "thermalmonitor";
      tag = "${version}";
      sha256 = "sha256-4+SNHlqWB/nLkWc2pOY5CAIkcT7NE/fscV1RfhqJ5CM=";
    };

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plasma/plasmoids/org.kde.olib.thermalmonitor
      cp -r package/* $out/share/plasma/plasmoids/org.kde.olib.thermalmonitor
      runHook postInstall
    '';

    passthru.updateScript = pkgs.nix-update-script {};
  };
in {
  home.packages = [thermal-monitor];
}

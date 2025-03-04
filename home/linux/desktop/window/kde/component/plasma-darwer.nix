{pkgs, ...}: let
  plasma-darwer = pkgs.stdenvNoCC.mkDerivation rec {
    name = "plasma-darwer";
    version = "2.0.1";

    src = pkgs.fetchurl {
      url = "https://github.com/p-connor/plasma-drawer/releases/download/v${version}/plasma-drawer-${version}.plasmoid";
      hash = "sha256-MY7LWu2nqOvznVD6NdFlIz1YF6YVFG0RkZqsPkRa6UU=";
    };

    nativeBuildInputs = [pkgs.unzip];
    unpackPhase = ''
      echo "Skippiong unpackPhase"
    '';

    propagatedUserEnvPkgs = with pkgs.kdePackages; [kconfig];
    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir tmpdir
      unzip $src -d tmpdir

      mkdir -p $out/share/plasma/plasmoids/p-connor.plasma-drawer
      cp -r tmpdir/* $out/share/plasma/plasmoids/p-connor.plasma-drawer

      runHook postInstall
    '';
  };
in {
  home.packages = [plasma-darwer];
}

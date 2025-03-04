{pkgs, ...}: let
  applet-window-title = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "applet-window-title";
    version = "v0.9.0";

    src = pkgs.fetchFromGitHub {
      owner = "dhruv8sh";
      repo = "plasma6-window-title-applet";
      tag = "${version}";
      sha256 = "sha256-pFXVySorHq5EpgsBz01vZQ0sLAy2UrF4VADMjyz2YLs=";
    };

    propagatedUserEnvPkgs = with pkgs.kdePackages; [kconfig];

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/plasma/plasmoids/org.kde.windowtitle
      cp -r $src/* $out/share/plasma/plasmoids/org.kde.windowtitle
      runHook postInstall
    '';

    passthru.updateScript = pkgs.nix-update-script {};
  };
in {
  home.packages = [
    applet-window-title
  ];
}

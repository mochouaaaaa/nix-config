{pkgs, ...}: let
  resources-monitor = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "resources-monitor";
    version = "v3.0.1";

    src = pkgs.fetchFromGitHub {
      owner = "orblazer";
      repo = "plasma-applet-resources-monitor";
      tag = "${version}";
      sha256 = "sha256-pBswbKoMGAmUU0jIMLPiFFiTIohQsuC+XHkpZRAN5Ok=";
    };

    dontWrapQtApps = true;

    propagatedUserEnvPkgs = with pkgs.kdePackages; [
      libksysguard
      kdeplasma-addons
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/plasma/plasmoids/org.kde.plasma.resources-monitor
      cp -r package/* $out/share/plasma/plasmoids/org.kde.plasma.resources-monitor
      runHook postInstall
    '';

    passthru.updateScript = pkgs.nix-update-script {};
  };
in {
  home.packages = [resources-monitor];
}

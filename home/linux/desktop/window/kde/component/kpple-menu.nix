{pkgs, ...}: let
  kpple-menu = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "kppleMenu";
    version = "6.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "ChrTall";
      repo = "kppleMenu";
      tag = "v${version}";
      sha256 = "sha256-TLLvjZdGdT/8zVpPGwnRofr1NZVDvBUIUpp/kwk3kR4=";
    };

    propagatedUserEnvPkgs = with pkgs.kdePackages; [kconfig];

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/plasma/plasmoids/com.github.chrtall.kppleMenu
      cp -r package/* $out/share/plasma/plasmoids/com.github.chrtall.kppleMenu
      runHook postInstall
    '';

    passthru.updateScript = pkgs.nix-update-script {};
  };
in {
  home.packages = [
    kpple-menu
  ];
}
